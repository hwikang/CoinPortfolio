//
//  MockCoinListUsecase.swift
//  PortfolioTests
//
//  Created by paytalab on 7/28/24.
//

import Foundation
@testable import Portfolio

class MockCoinListUsecase: CoinListUsecaseProtocol {

    var fetchListResult: Result<[CoinListItem], NetworkError> = .success([])
    var getFavoriteListResult: Result<[CoinListItem], CoreDataError> = .success([])
    var saveFavoriteResult: Result<Bool, CoreDataError> = .success(true)
    var deleteFavoriteListResult: Result<Bool, CoreDataError> = .success(true)
    var resetFavoriteListResult: Result<Bool, CoreDataError> = .success(true)
    
    func fetchList(query: String) async -> Result<[CoinListItem], NetworkError> {
        return fetchListResult
    }
    
    func getFavoriteList(query: String) -> Result<[CoinListItem], CoreDataError> {
        return getFavoriteListResult
    }
    
    func saveFavorite(item: CoinListItem) -> Result<Bool, CoreDataError> {
        return saveFavoriteResult
    }
    
    func deleteFavoriteList(symbol: String) -> Result<Bool, CoreDataError> {
        return deleteFavoriteListResult
    }
    
    func resetFavoriteList() -> Result<Bool, CoreDataError> {
        return resetFavoriteListResult
    }
}
