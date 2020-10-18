//
//  NetworkError.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 22/08/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Alamofire

enum NetworkError: LocalizedError {
    case alamofireError(AFError)
    case urlError(URLError)
    case decodingError(DecodingError)
    case unknown

    var errorDescription: String? {
        switch self {
        case .alamofireError(let error):
            return "Alamofire Error: " + error.localizedDescription
        case .urlError(let error):
            return "URL Error: " + error.localizedDescription
        case .decodingError(let error):
            return "Decoding Error: " + error.localizedDescription
        case .unknown:
            return "Unknown Error" 
        }
    }
}
