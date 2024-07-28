//
//  CoinListRepository.swift
//  Portfolio
//
//  Created by paytalab on 7/26/24.
//

import Foundation

public struct CoinListRepository: CoinListRepositoryProtocol {
    private let network: CoinListNetwork, coreData: CoinListCoreData
    public init(network: CoinListNetwork, coreData: CoinListCoreData) {
        self.network = network
        self.coreData = coreData
    }
    
    public func fetchList() async -> Result<[CoinListItem], NetworkError> {
        await network.fetchList()
    }
    
    public func saveFavorite(item: CoinListItem) -> Result<Bool, CoreDataError> {
        coreData.saveFavorite(item: item)
    }
    
    public func getFavoriteList() -> Result<[CoinListItem], CoreDataError> {
        coreData.getFavoriteList()
    }
    public func getFavoriteList(query: String) -> Result<[CoinListItem], CoreDataError> {
        coreData.getFavoriteList(query: query)
    }
    
    public func deleteFavoriteList(symbol: String) -> Result<Bool, CoreDataError> {
        coreData.deleteFavoriteUser(symbol: symbol)
    }
    
    public func resetFavoriteList() -> Result<Bool, CoreDataError> {
        coreData.resetFavoriteList()
    }
    
    
}
