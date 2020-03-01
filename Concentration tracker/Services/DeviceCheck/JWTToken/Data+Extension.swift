//
//  Data+Extension.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 18.11.2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
//

import Foundation

extension Data {
    func base64EncodedURLString() -> String {
        return base64EncodedString()
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
    }
}
