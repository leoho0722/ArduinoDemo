//
//  NetworkManager.swift
//  ArduinoDemo
//
//  Created by Leo Ho on 2023/10/7.
//

import Foundation

import LHNetworkHelpers

final class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    enum NetworkError: Error {
        
        case unknownError
        
        case connectionError
        
        case invalidResponse
        
        case jsonDecodeFailed
        
        case invalidRequest     // statusCode 400
        
        case authorizationError // statusCode 401
        
        case notFound           // statusCode 404
        
        case internalError      // statusCode 500
        
        case serverError        // statusCode 502
        
        case serverUnavailable  // statusCode 503
    }
    
    /// 請求 API 資料
    /// - Parameters:
    ///   - url: Server 網址
    ///   - method: HTTP Method
    ///   - parameters: HTTP body 參數
    /// - Returns: HTTP Response
    func requestData<E, D>(with url: URL,
                           method: HttpConstants.HttpMethod,
                           parameters: E) async throws -> D where E: Encodable, D: Decodable {
        let request = createURLRequest(with: url, method: method, parameters: parameters)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpURLResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        let statusCode = httpURLResponse.statusCode
        guard (200 ... 299).contains(statusCode) else {
            throw NetworkError.invalidRequest
        }
        guard let result = try? JSONDecoder().decode(D.self, from: data) else {
            throw NetworkError.jsonDecodeFailed
        }
        return result
    }
    
    /// 建立 URLRequest
    /// - Parameters:
    ///   - url: Server 網址
    ///   - method: HTTP Method
    ///   - parameters: HTTP body 參數
    /// - Returns: 帶有上述參數的URLRequest
    private func createURLRequest<E>(with url: URL,
                                     method: HttpConstants.HttpMethod,
                                     parameters: E) -> URLRequest where E: Encodable {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = [
            HttpConstants.HttpHeaderFields.contentType.rawValue : HttpConstants.HttpContentType.json.rawValue
        ]
        
        if method != .get {
            request.httpBody = try? JsonCoder.toJsonData(data: parameters)
        }
        
        return request
    }
}
