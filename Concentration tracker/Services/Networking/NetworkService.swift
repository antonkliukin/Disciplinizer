//
//  NetworkService.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 22/08/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Alamofire

class NetworkState {
    static var isConnected: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

extension RequestBuilder {
    func asURLRequest() throws -> URLRequest {
        var urlRequest = try URLRequest(url: baseURL.appendingPathComponent(path),
                                        method: self.method,
                                        headers: self.headers)
        urlRequest.httpBody = self.body
        urlRequest.allHTTPHeaderFields = self.headers
        urlRequest = method == .post ?
            try URLEncoding(destination: .queryString).encode(urlRequest, with: queryParameters) :
            try URLEncoding.default.encode(urlRequest, with: queryParameters)
        urlRequest.timeoutInterval = 30

        return urlRequest
    }
}

final class NetworkManager {

    let sessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders

        let manager = Alamofire.SessionManager(configuration: configuration)

        manager.delegate.taskWillPerformHTTPRedirectionWithCompletion = { session, task, response, request, completion in
            completion(nil)
        }
        return manager
    }()

    static let shared = NetworkManager()
    static let successResponseCodes =  Array(200..<300)
    static let anyResponseCodes = Array(0..<600)

    func request<T: Codable>(requestBuilder: RequestBuilder,
                             acceptableCodes: [Int] = successResponseCodes,
                             _ completionHandler: @escaping (Swift.Result<T, Error>) -> Void) {
        request(requestBuilder: requestBuilder) { (result) in
            switch result {
            case .success(let data):
                do {
                    let value = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(value))
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("ERROR: Missing key: \(key), description: \(context.debugDescription)")
                } catch DecodingError.valueNotFound(let type, let context) {
                    print("ERROR: Missing value of type: \(type), description: \(context.debugDescription)")
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("ERROR: Unexpected type: \(type), description: \(context.debugDescription), \(context.codingPath)")
                } catch {
                    //completionHandler(.failure(error))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    private func request(requestBuilder: RequestBuilder,
                         acceptableCodes: [Int] = anyResponseCodes,
                         completionHandler: @escaping (Swift.Result<Data, Error>) -> Void) {
        sessionManager.request(requestBuilder).validate(statusCode: acceptableCodes).responseData(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                completionHandler(.success(value))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        })
    }
}
