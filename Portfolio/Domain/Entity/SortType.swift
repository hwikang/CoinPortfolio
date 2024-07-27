//
//  SortType.swift
//  Portfolio
//
//  Created by paytalab on 7/27/24.
//

import Foundation

public enum SortType: Equatable {
    case name(Order?)
    case price(Order?)
    case change(Order?)
    case quoteVolume(Order?)
    
    public static func == (lhs: SortType, rhs: SortType) -> Bool {
            switch (lhs, rhs) {
            case (.name, .name),
                 (.price, .price),
                 (.change, .change),
                 (.quoteVolume, .quoteVolume):
                return true
            default:
                return false
            }
        }
}

public enum Order {
    case ascending
    case descending
}
