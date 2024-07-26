//
//  CoinListItem.swift
//  Portfolio
//
//  Created by paytalab on 7/26/24.
//

import Foundation

public struct CoinListItem: Decodable {
    public let symbol: String
    public let close: String
    public let priceChangePercent: String
    public let priceChange: String
    public let quoteVolume: String
}
