//
//  CoinListUsecase.swift
//  Portfolio
//
//  Created by paytalab on 7/26/24.
//

import Foundation

public protocol CoinListUsecaseProtocol {
    func fetchList(query: String) -> Result<[CoinListItem], NetworkError>
    func saveFavorite(item: CoinListItem) -> Result<Bool, CoreDataError>
    func getFavotiteList() -> Result<[CoinListItem], CoreDataError>
    func deleteFavoriteList(symbol: String) -> Result<Bool, CoreDataError>
    func resetFavoriteList() -> Result<Bool, CoreDataError>
}
