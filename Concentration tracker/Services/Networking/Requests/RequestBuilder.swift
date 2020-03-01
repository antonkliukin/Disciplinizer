//
//  RequestBuilder.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 22/08/2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
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
        let jwt = JWT(keyID: "N3A6NPD78N", teamID: "F2Y5RN858Q", issueDate: Date(), expireDuration: 60 * 60)

        let p8 = """
-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgEaZxDK8DqdA6bLv0
xNotTLYecjWxme8X/aYv5nNnZ0qgCgYIKoZIzj0DAQehRANCAAS6bHsFlNbzRKTG
lOQr1BMUgqptef41jrz53FZBczcA6aMe6//0z1ODg2CaYvYXRcnBDT5qHWOACAD5
R21Od5Dc
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
