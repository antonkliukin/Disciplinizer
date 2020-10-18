//
//  ECKeyData.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 18.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

public typealias ECKeyData = Data

extension ECKeyData {
    public func toPrivateKey() throws -> ECPrivateKey {
        var error: Unmanaged<CFError>?

        guard let privateKey =
            SecKeyCreateWithData(self as CFData,
                                 [kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
                                  kSecAttrKeyClass: kSecAttrKeyClassPrivate,
                                  kSecAttrKeySizeInBits: 256] as CFDictionary,
                                 &error) else {
                                    throw error!.takeRetainedValue()
        }
        return privateKey
    }
}
