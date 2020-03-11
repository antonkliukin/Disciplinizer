//
//  PaymentsGatewayProtocol.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 10.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol PaymentsGatewayProtocol {
    func make(payment: Payment, completionHandler: @escaping (_ challenges: Result<Void, Error>) -> Void)
}
