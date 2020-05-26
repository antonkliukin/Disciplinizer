//
//  ExampleRequestManager.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 25/08/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

enum DeviceCheckRequesError: Error {
    case noInfoAboutDevice
}

struct DeviceCheckRequestModel: Codable {
    let deviceToken: String
    let timestamp = Date().currentTimeMillis()
    let transactionId = "randomStringD80"
    let bit0: Bool?
    let bit1: Bool?

    enum CodingKeys: String, CodingKey {
        case deviceToken = "device_token"
        case timestamp
        case transactionId = "transaction_id"
        case bit0
        case bit1
    }
}

struct DeviceCheckResponseModel: Codable {
    let bit0: Bool
    let bit1: Bool
    let lastUpdateTime: String

    enum CodingKeys: String, CodingKey {
        case lastUpdateTime = "last_update_time"
        case bit0
        case bit1
    }
}

class LockStateRequestManager {
    static let shared = LockStateRequestManager()
    private let networkManager: NetworkManager = .shared

    private init() {}

    func getBits(model: DeviceCheckRequestModel, completionHandler: @escaping (Result<DeviceCheckResponseModel, DeviceCheckRequesError>) -> Void) {
        let request = API.LockStateRequests.getBits(model: model)
        
        networkManager.request(requestBuilder: request) { (result: Result<DeviceCheckResponseModel?, Error>) in
            switch result {
            case .success(let model):
                if let model = model {
                    completionHandler(.success(model))
                } else {
                    completionHandler(.failure(.noInfoAboutDevice))
                }
            case .failure:
                completionHandler(.failure(.noInfoAboutDevice))
            }
        }
    }

    func updateBits(model: DeviceCheckRequestModel, completionHandler: @escaping (Result<String?, Error>) -> Void) {
        let request = API.LockStateRequests.updateBits(model: model)

        networkManager.request(requestBuilder: request, completionHandler)
    }
}
