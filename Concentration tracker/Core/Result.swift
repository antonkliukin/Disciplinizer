//
//  Result.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 15.02.2020.
//  Copyright © 2020 FutureCompanyName. All rights reserved.
//

import Foundation

struct CoreError: Error {
    var localizedDescription: String {
        return message
    }

    var message = ""
}

//typealias Result<T> = Swift.Result<T, Error>
