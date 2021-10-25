//
//  HTTP.swift
//  SimpleWeatherApp
//
//  Created by Griffin Storback on 2021-10-21.
//

import Foundation

struct HTTP {
    public typealias Headers = [String:String]
    
    public enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    public enum Task {
        case request
        case requestParameters(parameterEncoding: ParameterEncoding, urlParameters: Parameters?, bodyParameters: Parameters?)
        case requestParametersAndHeaders(parameterEncoding: ParameterEncoding, additionalHeaders: HTTP.Headers, urlParameters: Parameters?, bodyParameters: Parameters?)
    }
}
