//
//  NetworkService.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 22/08/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Alamofire

final class NetworkManager {

    let sessionManager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.af.default
        let manager = Alamofire.Session(configuration: configuration)
        
        return manager
    }()

    static let shared = NetworkManager()
    static let successResponseCodes =  Array(200..<300)
    static let anyResponseCodes = Array(0..<600)

    func request<T: Codable>(requestBuilder: ApiRequestProtocol,
                             acceptableCodes: [Int] = successResponseCodes,
                             _ completionHandler: @escaping (Swift.Result<T?, Error>) -> Void) {
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
                    completionHandler(.success(nil))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    private func request(requestBuilder: ApiRequestProtocol,
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
