//
//  CoinListNetwork.swift
//  Portfolio
//
//  Created by paytalab on 7/26/24.
//

import Foundation
import Alamofire

public struct CoinListNetwork {
    private let manager: NetworkManager
    init(manager: NetworkManager) {
        self.manager = manager
    }
    public func fetchList(query: String) async -> Result<[CoinListItem], NetworkError> {
        var url = "https://api.korbit.co.kr/v2/tickers"
        if !query.isEmpty {
            url += "?symbol=\(query.lowercased())"
        }
        
        let result: Result<[CoinListItem]?, NetworkError> = await manager.fetchData(url: url, method: .get)
        switch result {
        case let .success(coinList):
            return .success(coinList ?? [])
        case let .failure(error):
            return .failure(error)
        }
    }
}
