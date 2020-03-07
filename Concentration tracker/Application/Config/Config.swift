//
//  Config.swift
//  Concentration tracker
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
        case debug = "Debug"
        case release = "Release"
    }

    fileprivate enum ConfigurationKey: String {
        case deviceCheckBaseURL
    }

    static let shared = Config()

    fileprivate var configs: [ConfigurationKey: String]
    fileprivate var configuration: Configuration

    private init() {
        configs = [ConfigurationKey: String]()

        guard let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: Constants.config) as? String else {
            fatalError("Config - init(): No 'config' key in Config.plist.")
        }

        let splittedCurrentConfiguration = currentConfiguration.split(separator: "\n")

        guard let configuration = Configuration(rawValue: String(splittedCurrentConfiguration[0])) else {
                fatalError("Config - init(): Unsupported configuration.")
        }

        self.configuration = configuration

        guard let pathToDict = Bundle.main.path(forResource: "Config", ofType: "plist"),
            let dictFromPath = NSDictionary(contentsOfFile: pathToDict),
            let dict = dictFromPath.object(forKey: configuration.rawValue) as? [String: String] else {
                fatalError("Config - init(): No '" + configuration.rawValue + "' key in Config.plist.")
        }

        guard let deviceCheckBaseURL = dict[ConfigurationKey.deviceCheckBaseURL.rawValue]  else {
                fatalError("Config - init(): No '" + ConfigurationKey.deviceCheckBaseURL.rawValue + "' key in Config.plist.")
        }

        configs[.deviceCheckBaseURL] = deviceCheckBaseURL
    }
}

extension Config {
    func getDeviceCheckBaseURL() -> String {
        // TODO: Change to be production
        return configs[.deviceCheckBaseURL]!
    }
}
