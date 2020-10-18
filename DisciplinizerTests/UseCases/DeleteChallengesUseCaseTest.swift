//
//  DeleteChallengesUseCaseTest.swift
//  DisciplinizerTests
//
//  Created by Anton Kliukin on 08.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import XCTest

@testable import Disciplinizer

class DeleteChallengesUseCaseTest: XCTestCase {
    // https://www.martinfowler.com/bliki/TestDouble.html
    let challengesGatewaySpy = ChallengesGatewaySpy()

    var deleteChallengesUseCase: DeleteChallengeUseCase!

    // MARK: - Set up

    override func setUp() {
        super.setUp()

        deleteChallengesUseCase = DeleteChallengeUseCase(challengeGateway: challengesGatewaySpy)
    }

    override class func tearDown() {
        super.tearDown()

    }

    // MARK: - Tests

//    func test_delete_success_calls_completion_handler() {
//        // Given
//        let challengesToDelete = Challenge.createArray()
//        let expectedResultToBeReturned: Result<Void, Error> = Result.success(())
//        challengesGatewaySpy.deleteAllResultToBeReturned = expectedResultToBeReturned
//
//        let (_ challenge: Result<Void, Error>) -> VoidExpectation = expectation(description: "Delete Challenge Expectation")
//
//        // When
//        deleteChallengesUseCase.deleteAll(completionHandler: )
//
//        deleteBookUseCase.delete(book: bookToDelete) { (result) in
//            // Then
//            XCTAssertEqual(expectedResultToBeReturned, result, "Completion handler didn't return the expected result")
//            XCTAssertEqual(bookToDelete, self.booksGatewaySpy.deletedBook, "Incorrect book passed to the gateway")
//            deleteBookCompletionHandlerExpectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 1, handler: nil)
//    }
//
//    func test_delete_failure_calls_completion_handler() {
//        // Given
//        let bookToDelete = Book.createBook()
//        let expectedResultToBeReturned: Result<Void> = Result.failure(NSError.createError(withMessage: "Any message"))
//        booksGatewaySpy.deleteBookResultToBeReturned = expectedResultToBeReturned
//
//        let deleteBookCompletionHandlerExpectation = expectation(description: "Delete Book Expectation")
//
//        // When
//        deleteBookUseCase.delete(book: bookToDelete) { (result) in
//            // Then
//            XCTAssertEqual(expectedResultToBeReturned, result, "Completion handler didn't return the expected result")
//            XCTAssertEqual(bookToDelete, self.booksGatewaySpy.deletedBook, "Incorrect book passed to the gateway")
//            deleteBookCompletionHandlerExpectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 1, handler: nil)
//    }
}
