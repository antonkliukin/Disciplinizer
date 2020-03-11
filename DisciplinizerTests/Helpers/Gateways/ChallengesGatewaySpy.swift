//
//  ChallengesGatewaySpy.swift
//  DisciplinizerTests
//
//  Created by Anton Kliukin on 08.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation
@testable import Disciplinizer

class ChallengesGatewaySpy: ChallengesGatewayProtocol {

    var getChallengesResultToBeReturned: Result<[Challenge], Error>!
    var getLastChallengeResultToBeReturned: Result<Challenge?, Error>!
    var updateResultToBeReturned: Result<Challenge, Error>!
    var deleteAllResultToBeReturned: Result<Void, Error>!

    var deletedChallenge: Challenge!

    func add(parameters: ChallengeParameters, completionHandler: @escaping (_ challenge: Result<Challenge, Error>) -> Void) {

    }

    func delete(challenge: Challenge, completionHandler: @escaping (_ challenge: Result<Void, Error>) -> Void) {

    }

    func getAll(completionHandler: @escaping GetAllCompletionHandler) {

    }

    func getLast(completionHandler: @escaping (_ challenge: Result<Challenge?, Error>) -> Void) {

    }

    func update(challenge: Challenge, completionHandler: @escaping (_ challenge: Result<Challenge, Error>) -> Void) {

    }

    func deleteAll(completionHandler: @escaping (_ challenge: Result<Void, Error>) -> Void) {

    }

//    func fetchBooks(completionHandler: @escaping FetchBooksEntityGatewayCompletionHandler) {
//
//    }
//
//    func add(parameters: AddBookParameters, completionHandler: @escaping AddBookEntityGatewayCompletionHandler) {
//
//    }
//
//    func delete(book: Book, completionHandler: @escaping DeleteBookEntityGatewayCompletionHandler) {
//        deletedBook = book
//        completionHandler(deleteBookResultToBeReturned)
//    }
}
