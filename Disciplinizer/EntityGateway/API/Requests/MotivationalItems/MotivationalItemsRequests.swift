//
//  MotivationalItemsRequests.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 24.09.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

struct MotivationalItemsRequest: ApiRequestProtocol {
    func asURLRequest() throws -> URLRequest {
        let url: URL! = URL(string: "")
        
        let request = URLRequest(url: url)
        
        return request
    }
}
