//
//  Web3API.swift
//  
//
//  Created by Yaroslav Yashin on 11.07.2022.
//

import Foundation

public protocol Web3API {
    var chain: Chain? { get set }
    var url: URL { get }
    var session: URLSession { get }
    var apiKey: String { get }
    var headers: [String: String] { get }
}
