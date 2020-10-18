//
//  RequestBuilder.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 22/08/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Alamofire

protocol ApiRequestProtocol: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var baseURL: URL { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var queryParameters: [String: Any]? { get }
    var urlRequest: URLRequest? { get }
}

extension ApiRequestProtocol {
    var method: HTTPMethod { return .get }
    var path: String { return "Default path" }
    var baseURL: URL { return URL(string: "Default base url")! }
    var headers: [String: String]? { return [:] }
    var body: Data? { return Data() }
    var queryParameters: [String: Any]? { return [:] }
    var urlRequest: URLRequest? {
        guard var urlRequest = try? URLRequest(url: baseURL.appendingPathComponent(path),
                                               method: self.method,
                                               headers: HTTPHeaders(self.headers!)) else { return nil }
        urlRequest.httpBody = self.body
        urlRequest.allHTTPHeaderFields = self.headers
        
        // TODO: Special conditions for POST?
//        urlRequest = method == .post ?
//            try URLEncoding(destination: .queryString).encode(urlRequest, with: queryParameters) :
//            try URLEncoding.default.encode(urlRequest, with: queryParameters)

        return urlRequest
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let request = urlRequest else {
            throw NetworkError.unknown
        }
        
        return request
    }
}
