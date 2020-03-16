//
//  ItemParameterUseCase.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol ItemParameterUseCaseProtocol {
    func select(motivationalItem: MotivationalItem, completionHandler: @escaping (_ challenge: Result<Void, Error>) -> Void)
    func getSelected(completionHandler: @escaping (_ challenge: Result<MotivationalItem, Error>) -> Void)
    func addPaid(motivationalItem: MotivationalItem, completionHandler: @escaping (_ challenge: Result<Void, Error>) -> Void)
    func getPaid(completionHandler: @escaping (_ challenge: Result<MotivationalItem, Error>) -> Void)
}

class ItemParameterUseCase: ItemParameterUseCaseProtocol {
    let challengesParametersGateway: ChallengeParametersGatewayProtocols

    init(challengesParametersGateway: ChallengeParametersGatewayProtocols) {
        self.challengesParametersGateway = challengesParametersGateway
    }

    func select(motivationalItem: MotivationalItem, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        challengesParametersGateway.select(motivationalItem: motivationalItem, completionHandler: completionHandler)
    }

    func getSelected(completionHandler: @escaping (Result<MotivationalItem, Error>) -> Void) {
        challengesParametersGateway.getCurrentMotivationalItem(completionHandler: completionHandler)
    }

    func addPaid(motivationalItem: MotivationalItem, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        challengesParametersGateway.addPaid(motivationalItem: motivationalItem, completionHandler: completionHandler)
    }

    func getPaid(completionHandler: @escaping (Result<MotivationalItem, Error>) -> Void) {
        challengesParametersGateway.getPaid(completionHandler: completionHandler)
    }
}
