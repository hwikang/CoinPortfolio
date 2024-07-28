//
//  CoinListRepositoryProtocol.swift
//  Portfolio
//
//  Created by paytalab on 7/26/24.
//
import Foundation

public protocol CoinListRepositoryProtocol {
    func fetchList() async -> Result<[CoinListItem], NetworkError>
    func saveFavorite(item: CoinListItem) -> Result<Bool, CoreDataError>
    func getFavoriteList() -> Result<[CoinListItem], CoreDataError>
    func getFavoriteList(query: String) -> Result<[CoinListItem], CoreDataError>
    func deleteFavoriteList(symbol: String) -> Result<Bool, CoreDataError>
    func resetFavoriteList() -> Result<Bool, CoreDataError>
}
