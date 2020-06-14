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
    func deletePaid(completionHandler: @escaping (Result<Void, Error>) -> Void)
}

class MotivationParameterUseCase: MotivationParameterUseCaseProtocol {
    let challengesParametersGateway: ChallengeParametersGatewayProtocols

    init(challengesParametersGateway: ChallengeParametersGatewayProtocols) {
        self.challengesParametersGateway = challengesParametersGateway
    }

    func select(motivationalItem: MotivationalItem, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        challengesParametersGateway.save(motivationalItem: motivationalItem, completionHandler: { result in
            NotificationCenter.default.post(name: Notification.Name.selectedMotivationalItemChanged, object: nil)
            
            completionHandler(result)
        })
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
    
    func deletePaid(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        challengesParametersGateway.deletePaid(completionHandler: completionHandler)
    }
}
