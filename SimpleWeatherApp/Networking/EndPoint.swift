//
//  EndPoint.swift
//  SimpleWeatherApp
//
//  Created by Griffin Storback on 2021-10-21.
//

import Foundation

protocol EndPointProtocol {
    var baseURL: URL { get }
    var path: String { get }
    var url: URL { get }
    var httpMethod: HTTP.Method { get }
    var task: HTTP.Task { get }
    var headers: HTTP.Headers { get }
}

// If there are many endpoints, should break this up into multiple files (e.g. UserEndPoint, WeatherEndPoint, LocationEndPoint etc.)
public enum EndPoint {
    case weather(id: Int)
    case searchLocations(searchText: String)
    
}

extension EndPoint: EndPointProtocol {
    var baseURLString: String {
        "https://www.metaweather.com/api"
    }
    
    var baseURL: URL {
        guard let url = URL(string: baseURLString) else {
            fatalError("baseURL String could not be converted to URL (EndPoints.swift)")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .weather(let id): return "/location/\(id)"
        case .searchLocations: return "/location/search"
        }
    }
    
    var url: URL {
        return baseURL.appendingPathComponent(path)
    }
    
    var httpMethod: HTTP.Method {
        return .get
    }
    
    var task: HTTP.Task {
        switch self {
        case .searchLocations(let searchText): return .requestParameters(parameterEncoding: .urlEncoding, urlParameters: ["query":searchText], bodyParameters: nil)
        default: return .request
        }
    }
    
    var headers: HTTP.Headers {
        return [:]
    }
}
