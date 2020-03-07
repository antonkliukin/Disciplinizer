//
//  KeychainService.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 22/08/2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
//

import KeychainAccess

class KeychainService {
    struct KeychainError: Error {
        var status: OSStatus

        var localizedDescription: String {
            if #available(iOS 11.3, *) {
                return SecCopyErrorMessageString(status, nil) as String? ?? "Unknown error."
            } else {
                return "Unknown error."
            }
        }
    }

    enum Constants {
        static let keychainAccessId = rootName

        static let isAppLocked = getName(name: "isAppLocked")
        static let isGuideWatched = getName(name: "isGuideWatched")

        private static let rootName = "com.d80.concentrationTracker"

        private static func getName(name: String) -> String {
            return rootName + "." + name
        }
    }

    static let shared = KeychainService()

    var keychain: Keychain

    private init() {
        keychain = Keychain(service: Constants.keychainAccessId)
    }

    /// Value will be accessible only after authentication
    fileprivate func setProtectedValue(value: String, key: String) throws {
        let value = value.data(using: String.Encoding.utf8)!

        let access = SecAccessControlCreateWithFlags(nil,
                                                     kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                                     .userPresence,
                                                     nil)

        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccessControl as String: access as Any,
                                    kSecValueData as String: value,
                                    kSecAttrService as String: key]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError(status: status)
        }
    }

    fileprivate func deleteProtectedValue(key: String) {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: key]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess else {
            print("Error occurred while trying to delete item with key: \(key): \(KeychainError(status: status).localizedDescription)")
            return
        }
    }

    fileprivate func setValue(key: String, value: String) {
        keychain[key] = value
    }

    fileprivate func getValue(key: String) -> String? {
        return keychain[key]
    }

    fileprivate func remove(at key: String) {
        try? keychain.remove(key)
    }

    fileprivate func removeAll() {
        do {
            try keychain.removeAll()
        } catch { }
    }
}

extension KeychainService {
    static func setLockStateTo(_ state: LockState) {
        KeychainService.shared.setValue(key: Constants.isAppLocked, value: state.rawValue)
    }

    static func getLockState() -> LockState? {
        guard let stringState = KeychainService.shared.getValue(key: Constants.isAppLocked),
              let state = LockState(rawValue: stringState) else {
                return nil
        }

        return state
    }

    static func setGuideState(isWatched: Bool) {
        KeychainService.shared.setValue(key: Constants.isGuideWatched, value: isWatched ? "true" : "false")
    }

    static func getGuideState() -> Bool {
        guard let isWatched = KeychainService.shared.getValue(key: Constants.isGuideWatched) else { return false }

        return isWatched == "true"
    }
}
