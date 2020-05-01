//
//  ItemParameterUseCase.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol MotivationParameterUseCaseProtocol {
    func select(motivationalItem: MotivationalItem, completionHandler: @escaping (Result<Void, Error>) -> Void)
    func getSelectedMotivationalItem(completionHandler: @escaping (Result<MotivationalItem, Error>) -> Void)
    func addPaid(motivationalItem: MotivationalItem, completionHandler: @escaping (Result<Void, Error>) -> Void)
    func getPaid(completionHandler: @escaping (Result<MotivationalItem?, Error>) -> Void)
}

class ItemParameterUseCase: MotivationParameterUseCaseProtocol {
    let challengesParametersGateway: ChallengeParametersGatewayProtocols

    init(challengesParametersGateway: ChallengeParametersGatewayProtocols) {
        self.challengesParametersGateway = challengesParametersGateway
    }

    func select(motivationalItem: MotivationalItem, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        challengesParametersGateway.save(motivationalItem: motivationalItem, completionHandler: completionHandler)
    }

    func getSelectedMotivationalItem(completionHandler: @escaping (Result<MotivationalItem, Error>) -> Void) {
        challengesParametersGateway.getMotivationalItem(completionHandler: completionHandler)
    }

    func addPaid(motivationalItem: MotivationalItem, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        challengesParametersGateway.savePaid(motivationalItem: motivationalItem, completionHandler: completionHandler)
    }

    func getPaid(completionHandler: @escaping (Result<MotivationalItem?, Error>) -> Void) {
        challengesParametersGateway.getPaid(completionHandler: completionHandler)
    }
}
