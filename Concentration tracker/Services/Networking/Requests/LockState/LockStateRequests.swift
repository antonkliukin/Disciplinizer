//
//  ExampleUserRequests.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 25/08/2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
//

import Alamofire

extension API {
    enum LockStateRequests: LockStateRequestBuilder {
        case getBits(model: DeviceCheckRequestModel)
        case updateBits(model: DeviceCheckRequestModel)

        var method: HTTPMethod {
            switch self {
            case .getBits: return .post
            case .updateBits: return .post
            }
        }

        var path: String {
            switch self {
            case .getBits:
                return "query_two_bits"
            case .updateBits:
                return "update_two_bits"
            }
        }

        var body: Data? {
            switch self {
            case .getBits(let model):
                let data = try? JSONEncoder().encode(model)
                return data
            case .updateBits(let model):
                let data = try? JSONEncoder().encode(model)
                return data
            }
        }
    }
}
