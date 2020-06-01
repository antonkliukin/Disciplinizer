//
//  Config.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 22/08/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

final class Config {
    fileprivate enum Constants {
        static let config = "Config"
    }

    fileprivate enum Configuration: String {
        case dev = "Dev"
        case test = "Test"
        case prod = "Prod"
    }

    fileprivate enum ConfigurationKey: String {
        case deviceCheckBaseURL
        case adUnitID
        case testDurationInMinutes
        case numberOfAds
        case chatMessageDelay
    }

    static let shared = Config()

    fileprivate var configs: [ConfigurationKey: String]
    fileprivate var configuration: Configuration?

    private init() {
        configs = [ConfigurationKey: String]()

        guard let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: Constants.config) as? String else {
            assertionFailure("Config - init(): No 'config' key in Config.plist.")
            return
        }

        let splittedCurrentConfiguration = currentConfiguration.split(separator: "\n")

        guard let configuration = Configuration(rawValue: String(splittedCurrentConfiguration[0])) else {
            assertionFailure("Config - init(): Unsupported configuration.")
            return
        }

        self.configuration = configuration

        guard let pathToDict = Bundle.main.path(forResource: "Config", ofType: "plist"),
            let dictFromPath = NSDictionary(contentsOfFile: pathToDict),
            let dict = dictFromPath.object(forKey: configuration.rawValue) as? [String: String] else {
                assertionFailure("Config - init(): No '" + configuration.rawValue + "' key in Config.plist.")
                return
        }

        guard let deviceCheckBaseURL = dict[ConfigurationKey.deviceCheckBaseURL.rawValue]  else {
            assertionFailure("Config - init(): No '" + ConfigurationKey.deviceCheckBaseURL.rawValue + "' key in Config.plist.")
            return
        }
        
        guard let adUnitID = dict[ConfigurationKey.adUnitID.rawValue]  else {
            assertionFailure("Config - init(): No '" + ConfigurationKey.adUnitID.rawValue + "' key in Config.plist.")
            return
        }

        configs[.deviceCheckBaseURL] = deviceCheckBaseURL
        configs[.adUnitID] = adUnitID
        configs[.testDurationInMinutes] = dict[ConfigurationKey.testDurationInMinutes.rawValue]
        configs[.numberOfAds] = dict[ConfigurationKey.numberOfAds.rawValue]
        configs[.chatMessageDelay] = dict[ConfigurationKey.chatMessageDelay.rawValue]
    }
}

extension Config {
    func getDeviceCheckBaseURL() -> String {
        return configs[.deviceCheckBaseURL]!
    }
    
    func getAdUnitID() -> String {
        return configs[.adUnitID]!
    }
    
    func devDurationInMinutes() -> Int? {
        guard let duration = configs[.testDurationInMinutes] else { return nil }
        
        return Int(duration)
    }
    
    func numberOfAds() -> Int? {
        guard let numberOfAds = configs[.numberOfAds] else { return nil }
        
        return Int(numberOfAds)
    }
    
    func chatMessageDelay() -> Int? {
        guard let chatMessageDelay = configs[.chatMessageDelay] else { return nil }
        
        return Int(chatMessageDelay)
    }
}
