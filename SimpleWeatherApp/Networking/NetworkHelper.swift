//
//  NetworkHelper.swift
//  SimpleWeatherApp
//
//  Created by Griffin Storback on 2021-10-22.
//

import Foundation

public typealias NetworkTaskCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void
public typealias Parameters = [String:Any]

/// This struct contains a collection of static methods used to set up a network request, start a dataTask for the request, handle the HTTP response, and decode the data into a decodable type.
struct NetworkHelper {
    
    /// Calls getDataFromEndPointAndHandleResponse, and decodes the result.
    @discardableResult
    static func getDataFromEndPointHandleResponseAndDecodeData<T: Decodable>(session: URLSession = URLSession.shared, decodeTo type: T.Type, endPoint: EndPointProtocol, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? {
        return getDataFromEndPointAndHandleResponse(endPoint: endPoint) { result in
            switch result {
            case .success(let data):
                do {
                    // Uncomment line below to debug decoding errors (prints the raw json response)
                    print(try JSONSerialization.jsonObject(with: data, options: .mutableContainers))
                    
                    let decodedData = try JSONDecoder().decode(type, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(NetworkError.unableToDecode))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Calls getDataFromEndPoint, and handles the HTTP response
    @discardableResult
    static func getDataFromEndPointAndHandleResponse(session: URLSession = URLSession.shared, endPoint: EndPointProtocol, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
        return getDataFromEndPoint(session: session, endPoint: endPoint) { data, response, error in
            // network error
            if let error = error {
                completion(.failure(error))
            }
            
            if let response = response as? HTTPURLResponse {
                let result = handleNetworkResponse(response)
                switch result {
                case .success:
                    // make sure we actually received Data
                    guard let responseData = data else {
                        completion(.failure(NetworkError.noData))
                        return
                    }
                    
                    // return the Data, let the caller do proper decoding
                    completion(.success(responseData))
                    
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            }
        }
    }
    
    /// Builds request based on passed in endPoint, then creates a dataTask and starts it
    @discardableResult
    static func getDataFromEndPoint(session: URLSession = URLSession.shared, endPoint: EndPointProtocol, completion: @escaping NetworkTaskCompletion) -> URLSessionDataTask? {
        let task: URLSessionDataTask?
        
        do {
            let request = try buildRequest(from: endPoint)
            task = session.dataTask(with: request) { data, response, error in
                completion(data, response, error)
            }
        } catch {
            completion(nil, nil, error)
            task = nil
        }
        
        task?.resume()
        return task
    }
    
    /// Build the request based on values of the passed in 'endPoint'
    static func buildRequest(from endPoint: EndPointProtocol) throws -> URLRequest {
        var request = URLRequest(url: endPoint.url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = endPoint.httpMethod.rawValue
        
        do {
            switch endPoint.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyEncoding, let urlParameters, let bodyParameters):
                try configureParameters(request: &request, bodyEncoding: bodyEncoding, urlParameters: urlParameters, bodyParameters: bodyParameters)
            case .requestParametersAndHeaders(let bodyEncoding, let additionalHeaders, let urlParameters, let bodyParameters):
                addAdditionalHeaders(additionalHeaders, request: &request)
                try configureParameters(request: &request, bodyEncoding: bodyEncoding, urlParameters: urlParameters, bodyParameters: bodyParameters)
            }
            return request
        } catch {
            throw error
        }
    }
    
    static func configureParameters(request: inout URLRequest, bodyEncoding: ParameterEncoding, urlParameters: Parameters?, bodyParameters: Parameters?) throws {
        do {
            try bodyEncoding.encode(request: &request, bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    static func addAdditionalHeaders(_ additionalHeaders: HTTP.Headers?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    static func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Void, Error> {
        switch response.statusCode {
        case 200...299: return .success(())
        case 401: return .failure(NetworkError.authenticationError)
        case 402...500: return .failure(NetworkError.badRequest)
        case 501...599: return .failure(NetworkError.failed)
        case 600: return .failure(NetworkError.outdated)
        default: return .failure(NetworkError.failed)
        }
    }
}
