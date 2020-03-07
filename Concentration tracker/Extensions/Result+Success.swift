//
//  Result+Success.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 27.10.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

// https://stackoverflow.com/questions/45837915/generic-swift-4-enum-with-void-associated-type
extension Result where Success == Void {
    static var success: Result {
        return .success(())
    }
}
