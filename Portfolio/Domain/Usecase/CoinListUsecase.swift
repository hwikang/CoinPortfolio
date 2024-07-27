//
//  CoinListUsecase.swift
//  Portfolio
//
//  Created by paytalab on 7/26/24.
//

import Foundation

public protocol CoinListUsecaseProtocol {
    func fetchList(query: String) async -> Result<[CoinListItem], NetworkError>
    func saveFavorite(item: CoinListItem) -> Result<Bool, CoreDataError>
    func getFavoriteList(query: String) -> Result<[CoinListItem], CoreDataError>
    func deleteFavoriteList(symbol: String) -> Result<Bool, CoreDataError>
    func resetFavoriteList() -> Result<Bool, CoreDataError>
}

public struct CoinListUsecase: CoinListUsecaseProtocol {
    private let repository: CoinListRepositoryProtocol
    public init(repository: CoinListRepositoryProtocol) {
        self.repository = repository
    }

    public func fetchList(query: String) async -> Result<[CoinListItem], NetworkError> {
        await repository.fetchList(query: query)
    }
    
    public func saveFavorite(item: CoinListItem) -> Result<Bool, CoreDataError> {
        repository.saveFavorite(item: item)
    }
    
    public func getFavoriteList(query: String) -> Result<[CoinListItem], CoreDataError> {
        if query.isEmpty {
            repository.getFavoriteList()
        } else {
            repository.getFavoriteList(query: query)
        }
        
    }
    
    public func deleteFavoriteList(symbol: String) -> Result<Bool, CoreDataError> {
        repository.deleteFavoriteList(symbol: symbol)
    }
    
    public func resetFavoriteList() -> Result<Bool, CoreDataError> {
        repository.resetFavoriteList()
    }
    
    
}
