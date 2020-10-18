//
//  ApiClient.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 16.09.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol ApiClientProtocol {
    func execute<T>(request: ApiRequestProtocol, completionHandler: @escaping (Result<ApiResponse<T>, Error>) -> Void)
}

protocol NetworkSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: NetworkSessionProtocol { }
//extension Alamofire.SessionManager: NetworkSessionProtocol {
//    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
//        
//        let sessionManager: Alamofire.SessionManager = {
//            let configuration = URLSessionConfiguration.default
//            configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//            
//            let manager = Alamofire.SessionManager(configuration: configuration)
//            
//            manager.delegate.taskWillPerformHTTPRedirectionWithCompletion = { session, task, response, request, completion in
//                completion(nil)
//            }
//            return manager
//        }()
//                
//        sessionManager.request(request).responseData(completionHandler: { (response) in
//            switch response.result {
//            case .success(let value):
//                completionHandler(value, nil, nil)
//            case .failure(let error):
//                completionHandler(nil, nil, error)
//            }
//        })
//    }
//}

class ApiClient: ApiClientProtocol {
    let networkSession: NetworkSessionProtocol
    
    init(urlSessionConfiguration: URLSessionConfiguration, completionHandlerQueue: OperationQueue) {
        networkSession = URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: completionHandlerQueue)
    }
    
    init(networkSession: NetworkSessionProtocol) {
        self.networkSession = networkSession
    }
        
    func execute<T>(request: ApiRequestProtocol, completionHandler: @escaping (Result<ApiResponse<T>, Error>) -> Void) {
        guard let request = request.urlRequest else { return }
        
        let dataTask = networkSession.dataTask(with: request) { (data, response, error) in
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(NetworkRequestError(error: error)))
                return
            }
            
            let successRange = 200...299
            if successRange.contains(httpUrlResponse.statusCode) {
                do {
                    let response = try ApiResponse<T>(data: data, httpUrlResponse: httpUrlResponse)
                    completionHandler(.success(response))
                } catch {
                    completionHandler(.failure(error))
                }
            } else {
                completionHandler(.failure(ApiError(data: data, httpUrlResponse: httpUrlResponse)))
            }
        }
        dataTask.resume()
    }
}
