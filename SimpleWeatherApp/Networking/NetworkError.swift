//
//  NetworkError.swift
//  SimpleWeatherApp
//
//  Created by Griffin Storback on 2021-10-22.
//

import Foundation

enum NetworkError: Error {
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
    case checkNetworkConnection
}
