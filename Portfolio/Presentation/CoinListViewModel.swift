//
//  CoinListViewModel.swift
//  Portfolio
//
//  Created by paytalab on 7/27/24.
//
import Foundation
import RxSwift
import RxCocoa

public protocol CoinListViewModelProtocol {
    func transform(input: CoinListViewModel.Input) -> CoinListViewModel.Output
}

public struct CoinListViewModel: CoinListViewModelProtocol {
    private let usecase: CoinListUsecaseProtocol
    private let disposeBag = DisposeBag()
    private let error = PublishRelay<String>()
    private let coinList = PublishRelay<[CoinListItem]>()
    private let favoriteCoinList = PublishRelay<[CoinListItem]>()
    private let allFavoriteCoinList = BehaviorRelay<[CoinListItem]>(value: [])

    init(usecase: CoinListUsecaseProtocol) {
        self.usecase = usecase
    }
    
    public struct Input {
        let searchQuery: Observable<String>
        let tabButtonType: Observable<TabButtonType>
        let saveCoin: Observable<CoinListItem>
        let deleceCoin: Observable<String>
        let sort: Observable<SortType>
    }
    
    public struct Output {
        let coinList: Observable<[CoinListItem]>
        let cellData: Observable<[CoinListItemCellData]>
        let error: Observable<String>
    }
    
    public func transform(input: Input) -> Output {
        input.searchQuery.bind { query in
            fetchList(query: query)
            getFavoriteList(query: query)
        }.disposed(by: disposeBag)
        
        input.saveCoin.bind { coin in
            saveFavorite(item: coin)
        }.disposed(by: disposeBag)
        
        input.deleceCoin.bind { symbol in
            deleteFavorite(symbole: symbol)
        }.disposed(by: disposeBag)

        let cellData = Observable.combineLatest(coinList, allFavoriteCoinList, favoriteCoinList, input.tabButtonType)
            .map { coinList, allFavoriteCoinList, favoriteCoinList, tabType in

                switch tabType {
                case .market:
                    let favoriteCoinSet = Set(favoriteCoinList)
                    let coinListCellData: [CoinListItemCellData] = coinList.map { coin in
                        if favoriteCoinSet.contains(coin) {
                            return .init(isSelected: true, data: coin)
                        } else {
                            return .init(isSelected: false, data: coin)
                        }
                    }
                    return coinListCellData
                case .favorite:
                    return favoriteCoinList.map { .init(isSelected: true, data: $0) }
                }
          
        }
        return Output(coinList: coinList.asObservable(), cellData: cellData,
                      error: error.asObservable())
    }
    
    private func fetchList(query: String) {
        Task {
            let result = await usecase.fetchList(query: query)
            switch result {
            case let .success(coinList):
                self.coinList.accept(coinList)
            case let .failure(error):
                self.error.accept(error.description)
                
            }
        }
    }
    private func getFavoriteList(query: String) {
        let result = usecase.getFavoriteList(query: query)
        switch result {
        case let .success(coinList):
            if query.isEmpty {
                allFavoriteCoinList.accept(coinList)
            }
            self.favoriteCoinList.accept(coinList)
        case let .failure(error):
            self.error.accept(error.description)
        }
    }
    
    private func saveFavorite(item: CoinListItem) {
        let result = usecase.saveFavorite(item: item)
        switch result {
        case .success:
            getFavoriteList(query: "")
        case let .failure(error):
            self.error.accept(error.description)
        }
    }
    
    private func deleteFavorite(symbole: String) {
        let result = usecase.deleteFavoriteList(symbol: symbole)
        switch result {
        case .success:
            getFavoriteList(query: "")
        case let .failure(error):
            self.error.accept(error.description)
        }
    }
}
