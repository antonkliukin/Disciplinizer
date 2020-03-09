//
//  UnblockApp.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 08.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

typealias UnblockAppUseCaseCompletionHandler = (_ challenge: Result<Bool, Error>) -> Void

protocol UnblockAppUseCaseProtocol {
    func unblock(completionHandler: @escaping UnblockAppUseCaseCompletionHandler)
}

class UnblockAppUseCase: UnblockAppUseCaseProtocol {
    init() {
    }

    func unblock(completionHandler: @escaping (Result<Bool, Error>) -> Void) {
    }
}
