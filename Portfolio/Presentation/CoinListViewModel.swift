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
    private let coinList = PublishRelay<Set<CoinListItem>>()
    private let favoriteCoinList = PublishRelay<Set<CoinListItem>>()
    private let allCoinList = BehaviorRelay<Set<CoinListItem>>(value: [])
    private let allFavoriteCoinList = BehaviorRelay<Set<CoinListItem>>(value: [])

    init(usecase: CoinListUsecaseProtocol) {
        self.usecase = usecase
        fetchAllCoinList()
        getAllFavoriteCoinList()
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
            getCoinList(query: query)
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
                createCellData(coinList: coinList, allFavoriteCoinList: allFavoriteCoinList, favoriteCoinList: favoriteCoinList, tabType: tabType, sort: sort)
            }
        
        return Output(cellData: cellData,
                      error: error.asObservable(),
                      toastMessage: toastMessage.asObservable())
    }
    
    internal func createCellData(coinList: Set<CoinListItem>, allFavoriteCoinList: Set<CoinListItem>, favoriteCoinList: Set<CoinListItem>, tabType: TabButtonType, sort: SortType) -> [CoinListItemCellData] {
        switch tabType {
        case .market:
            let favoriteCoinSet = Set(favoriteCoinList.map { $0.symbol })
            let sortedCoinList = sorted(coinList: Array(coinList), sort: sort)
            let coinListCellData: [CoinListItemCellData] = sortedCoinList.map { coin in
                if favoriteCoinSet.contains(coin.symbol) {
                    return .init(isSelected: true, data: coin)
                } else {
                    return .init(isSelected: false, data: coin)
                }
            }
            return coinListCellData
        case .favorite:
            let sortedFavoriteCoinList = sorted(coinList: Array(favoriteCoinList), sort: sort)
            return sortedFavoriteCoinList.map { .init(isSelected: true, data: $0) }
        }
    }
    
    internal func sorted(coinList: [CoinListItem], sort: SortType) -> [CoinListItem] {
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
    
    private func getCoinList(query: String) {
        if query.isEmpty {
            coinList.accept(allCoinList.value)
        } else {
            let result = allCoinList.value.filter { $0.symbol.contains(query.lowercased()) }
            coinList.accept(result)
        }
    }
    
    private func fetchAllCoinList() {
        Task {
            let result = await usecase.fetchList()
            switch result {
            case let .success(coinList):
                allCoinList.accept(Set(coinList))
                self.coinList.accept(Set(coinList))
            case let .failure(error):
                self.error.accept(error.description)
                
            }
        }
    }
    
    private func getFavoriteList(query: String) {
        if query.isEmpty {
            favoriteCoinList.accept(allFavoriteCoinList.value)
        } else {
            let result = allFavoriteCoinList.value.filter { $0.symbol.contains(query.lowercased()) }
            favoriteCoinList.accept(result)
        }
    }
    
    private func getAllFavoriteCoinList() {
        let result = usecase.getFavoriteList()
        switch result {
        case let .success(coinList):
            allFavoriteCoinList.accept(Set(coinList))
            self.favoriteCoinList.accept(Set(coinList))
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
