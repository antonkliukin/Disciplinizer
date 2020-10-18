//
//  ECPrivateKey.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 18.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation
import CommonCrypto

public typealias ECPrivateKey = SecKey

extension ECPrivateKey {
    public func es256Sign(digest: String) throws -> String {
        guard let message = digest.data(using: .utf8) else {
            throw JWTError.digestDataCorruption
        }

        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256((message as NSData).bytes, CC_LONG(message.count), &hash)
        let digestData = Data(hash)

        let algorithm = SecKeyAlgorithm.ecdsaSignatureDigestX962SHA256

        guard SecKeyIsAlgorithmSupported(self, .sign, algorithm)
            else {
                throw JWTError.keyNotSupportES256Signing
        }

        var error: Unmanaged<CFError>?

        guard let signature = SecKeyCreateSignature(self, algorithm, digestData as CFData, &error) else {
            throw error!.takeRetainedValue()
        }

        let rawSignature = try (signature as ASN1).toRawSignature()

        return rawSignature.base64EncodedURLString()
    }
}
