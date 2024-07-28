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
    private let toastMessage = PublishRelay<String>()
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
        let resetFavorite: Observable<Void>
    }
    
    public struct Output {
        let cellData: Observable<[CoinListItemCellData]>
        let error: Observable<String>
        let toastMessage: Observable<String>
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

        input.resetFavorite.bind {
            resetFavoriteList()
        }.disposed(by: disposeBag)
        let cellData = Observable.combineLatest(coinList, allFavoriteCoinList, favoriteCoinList, input.tabButtonType, input.sort)
            .map { coinList, allFavoriteCoinList, favoriteCoinList, tabType, sort in

                switch tabType {
                case .market:
                    
                    let favoriteCoinSet = Set(favoriteCoinList.map { $0.symbol })
                    let sortedCoinList = sorted(coinList: coinList, sort: sort)
                    let coinListCellData: [CoinListItemCellData] = sortedCoinList.map { coin in
                        if favoriteCoinSet.contains(coin.symbol) {
                            return .init(isSelected: true, data: coin)
                        } else {
                            return .init(isSelected: false, data: coin)
                        }
                    }
                    return coinListCellData
                case .favorite:
                    let sortedFavoriteCoinList = sorted(coinList: favoriteCoinList, sort: sort)
                    return sortedFavoriteCoinList.map { .init(isSelected: true, data: $0) }
                }
          
            }
        
        return Output(cellData: cellData,
                      error: error.asObservable(),
                      toastMessage: toastMessage.asObservable())
    }
    
    private func sorted(coinList: [CoinListItem], sort: SortType) -> [CoinListItem] {
        switch sort {
        case let .name(order):
            switch order {
            case .ascending:  return coinList.sorted { $0.symbol < $1.symbol }
            case .descending:  return coinList.sorted { $0.symbol > $1.symbol }
            default: return coinList
            }
            
        case let .price(order):
            switch order {
            case .ascending:  return coinList.sorted { $0.close < $1.close }
            case .descending:   return coinList.sorted { $0.close > $1.close }
            default: return coinList
            }
        case let .change(order):
            switch order {
            case .ascending:  return coinList.sorted { $0.priceChangePercent < $1.priceChangePercent }
            case .descending:   return coinList.sorted { $0.priceChangePercent > $1.priceChangePercent }
            default: return coinList
            }
            
        case let .quoteVolume(order):
            switch order {
            case .ascending: return coinList.sorted { $0.quoteVolume < $1.quoteVolume }
            case .descending: return coinList.sorted { $0.quoteVolume > $1.quoteVolume }
            default: return coinList
            }
        }
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
            toastMessage.accept("즐겨찾기 저장 완료")
            getFavoriteList(query: "")
        case let .failure(error):
            self.error.accept(error.description)
        }
    }
    
    private func deleteFavorite(symbole: String) {
        let result = usecase.deleteFavoriteList(symbol: symbole)
        switch result {
        case .success:
            toastMessage.accept("즐겨찾기 해제 완료")
            getFavoriteList(query: "")
        case let .failure(error):
            self.error.accept(error.description)
        }
    }
    
    private func resetFavoriteList() {
        let result = usecase.resetFavoriteList()
        switch result {
        case .success:
            toastMessage.accept("즐겨찾기 일괄 해제 완료")
            getFavoriteList(query: "")
        case let .failure(error):
            self.error.accept(error.description)
        }
    }
}
