//
//  NetworkState.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 16.09.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Alamofire

class NetworkState {
    static var isConnected: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
