//
//  CoinListRepositoryProtocol.swift
//  Portfolio
//
//  Created by paytalab on 7/26/24.
//
import Foundation

public protocol CoinListRepositoryProtocol {
    func fetchCoinList(query: String) -> Result<[CoinListItem],Error>
    func saveFavorite(item: CoinListItem)
    func getFavotiteList() -> [CoinListItem]
    func deleteFavoriteList(symbol: String)
    func resetFavoriteList()
}
