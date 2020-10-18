//
//  TimeParameter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol DurationParameterUseCaseProtocol {
    func select(durationInMinutes: Int, completionHandler: @escaping (_ challenge: Result<Void, Error>) -> Void)
    func getSelectedDurationInMinutes(completionHandler: @escaping (_ challenge: Result<Int, Error>) -> Void)
}

class DurationParameterUseCase: DurationParameterUseCaseProtocol {
    let challengesParametersGateway: ChallengeParametersGatewayProtocols

    init(challengesParametersGateway: ChallengeParametersGatewayProtocols) {
        self.challengesParametersGateway = challengesParametersGateway
    }

    func select(durationInMinutes: Int, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        challengesParametersGateway.save(durationInMinutes: durationInMinutes, completionHandler: completionHandler)
    }

    func getSelectedDurationInMinutes(completionHandler: @escaping (Result<Int, Error>) -> Void) {
        challengesParametersGateway.getDurationInMinutes(completionHandler: completionHandler)
    }
}
