//
//  NetworkResponse.swift
//  Portfolio
//
//  Created by paytalab on 7/27/24.
//

import Foundation

public struct NetworkResponse<T: Decodable>: Decodable {
    let success: Bool
    let data: T?
}
