//
//  ParameterEncoding.swift
//  SimpleWeatherApp
//
//  Created by Griffin Storback on 2021-10-24.
//

import Foundation

/// Uses URLParameterEncoder and/or JSONParameterEncoder, depending on the case of self
public enum ParameterEncoding {
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding
    
    public func encode(request: inout URLRequest, bodyParameters: Parameters?, urlParameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder.encode(request: &request, with: urlParameters)
            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder.encode(request: &request, with: bodyParameters)
            case .urlAndJsonEncoding:
                guard let urlParameters = urlParameters, let bodyParameters = bodyParameters else { return }
                try URLParameterEncoder.encode(request: &request, with: urlParameters)
                try JSONParameterEncoder.encode(request: &request, with: bodyParameters)
            }
        }
    }
}

protocol ParameterEncoderProtocol {
    static func encode(request: inout URLRequest, with parameters: Parameters) throws
}

/// Don't use directly - use ParameterEncoding enum. URLParameterEncoder turns passed in 'Parameters' (typealias for [string:any]) into http query parameters (e.g. ...&query=the)
struct URLParameterEncoder: ParameterEncoderProtocol {
    static func encode(request: inout URLRequest, with parameters: Parameters) throws {
        guard let url = request.url else { throw NetworkError.missingURL }
        
        // convert url to URLComponents, add each query item, then update passed in request.url
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.queryItems = [URLQueryItem]()
            
            // create each URL query parameter from passed in parameters
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
            }
            request.url = urlComponents.url
        }
        
        // give default val for Content-Type if empty
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}

/// Don't use directly - use ParameterEncoding enum. JSONParameterEncoder adds the passed in 'Parameters' (typealias for [string:any]) to the body of the http request
struct JSONParameterEncoder: ParameterEncoderProtocol {
    static func encode(request: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = jsonAsData
            
            // give default val for Content-Type if empty
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}
