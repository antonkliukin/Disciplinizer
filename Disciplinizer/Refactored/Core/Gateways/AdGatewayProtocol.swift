//
//  AdGatewayProtocol.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 11.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol AdGatewayProtocol {
    func watchAd(completionHandler: @escaping (_ challenges: Result<Void, Error>) -> Void)
}
