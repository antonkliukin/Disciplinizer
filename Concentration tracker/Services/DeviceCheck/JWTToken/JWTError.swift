//
//  JWTError.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 18.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

public enum JWTError: Error {
    case digestDataCorruption
    case invalidP8
    case invalidAsn1
    case keyNotSupportES256Signing
}

extension JWTError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .digestDataCorruption:
            return "Internal error."
        case .invalidP8:
            return "The .p8 string has invalid format."
        case .invalidAsn1:
            return "The ASN.1 data has invalid format."
        case .keyNotSupportES256Signing:
            return "The private key does not support ES256 signing"
        }
    }
}
