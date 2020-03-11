//
//  UnblockAppAfterFailedChallenge.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 10.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol MakePaymentUseCaseProtocol {
    func make(payment: Payment, completionHandler: @escaping (_ challenge: Result<Void, Error>) -> Void)
}

class MakePaymentUseCase: MakePaymentUseCaseProtocol {
    let paymentsGateway: PaymentsGatewayProtocol

    init(paymentsGateway: PaymentsGatewayProtocol) {
        self.paymentsGateway = paymentsGateway
    }

    func make(payment: Payment, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        paymentsGateway.make(payment: payment) { (paymentResult) in
            completionHandler(paymentResult)
        }
    }
}
