//
//  CoinListItem.swift
//  Portfolio
//
//  Created by paytalab on 7/26/24.
//

import Foundation

public struct CoinListItem: Decodable, Hashable {
    public let symbol: String
    public let close: Double
    public let priceChangePercent: Double
    public let priceChange: Double
    public let quoteVolume: Double
   
    enum CodingKeys: CodingKey {
        case symbol
        case close
        case priceChangePercent
        case priceChange
        case quoteVolume
    }
    init(symbol: String, close: Double, priceChangePercent: Double, priceChange: Double, quoteVolume: Double) {
        self.symbol = symbol
        self.close = close
        self.priceChangePercent = priceChangePercent
        self.priceChange = priceChange
        self.quoteVolume = quoteVolume
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        let closeString = try container.decode(String.self, forKey: .close)
        let priceChangePercentString = try container.decode(String.self, forKey: .priceChangePercent)
        let priceChangeString = try container.decode(String.self, forKey: .priceChange)
        let quoteVolumeString = try container.decode(String.self, forKey: .quoteVolume)
        self.close = Double(closeString) ?? 0
        self.priceChangePercent = Double(priceChangePercentString) ?? 0
        self.priceChange = Double(priceChangeString) ?? 0
        self.quoteVolume = Double(quoteVolumeString) ?? 0
    }
}
