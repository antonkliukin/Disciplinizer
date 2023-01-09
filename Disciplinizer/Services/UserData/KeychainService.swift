//
//  KeychainService.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 22/08/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation
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
        static let isFirstLaunch = getName(name: "isFirstLaunch")
        static let purchasedItem = getName(name: "purchasedItem")
        static let selectedItem = getName(name: "selectedItem")
        static let selectedTime = getName(name: "selectedTime")

        private static let rootName = "com.antonkliukin.disciplinizer"

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
    static var appLockState: LockState {
        get {
            guard let Stringstate = KeychainService.shared.getValue(key: Constants.isAppLocked),
                  let state = LockState(rawValue: Stringstate) else {
                    return .unlocked
            }

            return state
        }
        set {
            KeychainService.shared.setValue(key: Constants.isAppLocked, value: newValue.rawValue)
        }
    }

    static var isFirstLaunch: Bool {
        get {
            guard let isWatched = KeychainService.shared.getValue(key: Constants.isFirstLaunch) else { return true }

            return isWatched == "true"
        }
        
        set {
            KeychainService.shared.setValue(key: Constants.isFirstLaunch, value: newValue ? "true" : "false")
        }
    }
    
    static var purchasedItem: MotivationalItem? {
        get {
            guard let rawValue = KeychainService.shared.getValue(key: Constants.purchasedItem),
                  let item = MotivationalItem(rawValue: rawValue) else { return nil }

            return item
        }
        
        set {
            if let value = newValue {
                KeychainService.shared.setValue(key: Constants.purchasedItem, value: value.rawValue)
            } else {
                KeychainService.shared.remove(at: Constants.purchasedItem)
            }
        }
    }

    static var selectedItem: MotivationalItem? {
        get {
            guard let rawValue = KeychainService.shared.getValue(key: Constants.selectedItem),
                  let item = MotivationalItem(rawValue: rawValue) else { return nil }

            return item
        }
        
        set {
            if let value = newValue {
                KeychainService.shared.setValue(key: Constants.selectedItem, value: value.rawValue)
            }
        }
    }

    static var selectedTime: Int {
        get {
            guard let stringTime = KeychainService.shared.getValue(key: Constants.selectedTime), let time = Int(stringTime) else { return 30 }

            return time
        }
        
        set {
            KeychainService.shared.setValue(key: Constants.selectedTime, value: String(newValue))
        }
    }
}
