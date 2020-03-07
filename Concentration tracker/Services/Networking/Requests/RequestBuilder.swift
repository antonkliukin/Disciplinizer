//
//  RequestBuilder.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 22/08/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Alamofire

protocol RequestBuilder: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var baseURL: URL { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var queryParameters: [String: Any]? { get }
}

protocol LockStateRequestBuilder: RequestBuilder {}

extension LockStateRequestBuilder {
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
