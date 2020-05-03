//
//  PurchasesManager.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 09.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import StoreKit

protocol BetProtocol {
    var localizedPrice: String? { get }
    var id: String { get }
}

enum StoreProductPrice: CaseIterable, BetProtocol {
    case oneDollar
    case twoDollars
    case threeDollars
    case fourDollars
    case fiveDollars

    static var availiableBets: [String: String] = [:]

    var id: String {
        let baseId = "com.antonkliukin.disciplinizer"

        switch self {
        case .oneDollar: return baseId + ".one"
        case .twoDollars: return baseId + ".two"
        case .threeDollars: return baseId + ".three"
        case .fourDollars: return baseId + ".four"
        case .fiveDollars: return baseId + ".five"
        }
    }

    var localizedPrice: String? {
        return StoreProductPrice.availiableBets[self.id]
    }
}

enum PurchaseError: Error {
    case userError
    case gettingBetsError
    case generalError

    var localizedDescription: String {
        switch self {
        case .userError:
            return "User is not authorized to make payments"
        case .gettingBetsError:
            return "Cannot get avalilible bets"
        case .generalError:
            return "General error"
        }
    }
}

final class PurchasesManager: NSObject, SKPaymentTransactionObserver {
    static let shared = PurchasesManager()
    
    var didFinishPurchasing: ((Result<SKPaymentTransactionState, PurchaseError>) -> Void)?
    var getBetsCompletion: (([BetProtocol]) -> Void)?
    var productsRequest: SKProductsRequest?

    override init() {
        super.init()

        SKPaymentQueue.default().add(self)
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print("state", transaction.transactionState)
            
            switch transaction.transactionState {
            case .purchasing:
                didFinishPurchasing?(.success(.purchasing))
                print("Purchasing")
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                didFinishPurchasing?(.success(.purchased))
                print("Successfuly purchased product with id: \(transaction.payment.productIdentifier)")
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                didFinishPurchasing?(.failure(.generalError))
                print("Failed purchase")
            default:
                print("Other state")
            }
        }
    }

    var userCanMakePayment: Bool {
        return SKPaymentQueue.canMakePayments()
    }

    func makePurchase(price: StoreProductPrice, result: @escaping (Result<SKPaymentTransactionState, PurchaseError>) -> Void) {
        guard userCanMakePayment else {
            result(.failure(.userError))
            return
        }

        let paymentRequest = SKMutablePayment()
        paymentRequest.productIdentifier = price.id
        SKPaymentQueue.default().add(paymentRequest)

        didFinishPurchasing = result
    }

    func getAvailiableBets(completion: @escaping ([BetProtocol]) -> Void) {
        productsRequest = SKProductsRequest(productIdentifiers: Set(StoreProductPrice.allCases.map { $0.id }))
        productsRequest?.delegate = self
        productsRequest?.start()

        getBetsCompletion = completion
    }
}

extension PurchasesManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in response.products {
            StoreProductPrice.availiableBets[product.productIdentifier] = product.localizedPrice
        }

        getBetsCompletion?(StoreProductPrice.allCases)
    }
}

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
