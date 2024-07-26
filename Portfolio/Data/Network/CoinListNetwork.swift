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
        let url = "https://https://api.korbit.co.kr/v2/tickers"
        let parameters: Parameters = [
            "symbol": query
        ]
        return await manager.fetchData(url: url, method: .get, parameters: parameters)
    }
}
