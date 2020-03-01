//
//  P8.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 18.11.2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
//

import Foundation
import CommonCrypto

public typealias P8 = String

extension P8 {
    /// Convert PEM format .p8 file to DER-encoded ASN.1 data
    public func toASN1() throws -> ASN1 {
        let base64 = self
            .split(separator: "\n")
            .filter({ $0.hasPrefix("-----") == false })
            .joined(separator: "")

        guard let asn1 = Data(base64Encoded: base64) else {
            throw JWTError.invalidP8
        }
        return asn1
    }
}
