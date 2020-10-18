//
//  ExampleUserRequests.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 25/08/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Alamofire

protocol LockStateRequestProtocol: ApiRequestProtocol {}

extension LockStateRequestProtocol {
    var method: HTTPMethod {
        return .post
    }

    var baseURL: URL {
        return URL(string: Config.shared.getDeviceCheckBaseURL())!
    }

    var headers: [String: String]? {
        let jwt = JWT(keyID: "5W8TN2PZMS", teamID: "YJ66LV4LL7", issueDate: Date(), expireDuration: 60 * 60)

        let p8 = """
-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQg4RHua5U+RECwB2ws
HE9auhlDudxsH5rmiVu6VCAALgmgCgYIKoZIzj0DAQehRANCAAQ7H3xeSJyolvtO
zK3dyEEhj8r+ACwvdavi6or/Q1pLcee9XVdmVS8rg1qTgfpkXHT8mUDtCunlIcVJ
QBqpx79P
-----END PRIVATE KEY-----
"""

        guard let token = try? jwt.sign(with: p8) else {
            return nil
        }

        var parameters: [String: String] = [:]
        parameters["Authorization"] = "Bearer " + token
        parameters["Content-Type"] = "application/json"

        return parameters
    }

    var body: Data? {
        return nil
    }

    var queryParameters: [String: Any]? {
        return [:]
    }
}

extension API {
    enum LockStateRequest: LockStateRequestProtocol {
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
