//
//  AppLockManager.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 17.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import DeviceCheck

enum LockState: String {
    case locked, unlocked

    init(bitValue: Bool) {
        self = bitValue == true ? .locked : .unlocked
    }
}

protocol AppLockManagerProtocol {
    func getCurrentState(completion: @escaping (LockState) -> Void)
    func changeStateTo(_ state: LockState)
}

final class AppLockManager: AppLockManagerProtocol {
    static let shared = AppLockManager()

    private init() { }

    private func getDeviceToken(completion: @escaping (String?) -> Void) {
        let device = DCDevice.current

        guard device.isSupported else {
            completion("token")
            //fatalError("Use a real device to test this.")
            return
        }

        device.generateToken(completionHandler: { data, error in
            guard error == nil,
                let data = data else {
                    print("DeviceCheck token error.")
                    completion(nil)
                    return
            }

            let deviceToken = data.base64EncodedString()

            completion(deviceToken)
        })
    }

    func getCurrentState(completion: @escaping (LockState) -> Void) {

        if let stateFromKeychain = KeychainService.getLockState() {
            completion(stateFromKeychain)
            return
        }

        getDeviceToken { (deviceToken) in
            let model = DeviceCheckRequestModel(deviceToken: deviceToken ?? "", bit0: nil, bit1: nil)

            LockStateRequestManager.shared.getBits(model: model) { (result) in
                switch result {
                case .success(let response):
                    let state = LockState(bitValue: response.bit0)
                    completion(state)
                    print(response)
                case .failure(let error):
                    completion(.unlocked)
                    print(error)
                }
            }
        }
    }

    func changeStateTo(_ state: LockState) {
        let bit0 = state == .locked

        KeychainService.setLockStateTo(state)

        getDeviceToken { (deviceToken) in
            let model = DeviceCheckRequestModel(deviceToken: deviceToken ?? "", bit0: bit0, bit1: false)
            LockStateRequestManager.shared.updateBits(model: model, completionHandler: { (result) in
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
}
