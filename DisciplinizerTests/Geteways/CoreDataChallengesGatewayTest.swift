//
//  CoreDataBooksGatewayTest.swift
//  DisciplinizerTests
//
//  Created by Anton Kliukin on 08.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

// swiftlint:disable all
import XCTest

@testable import Disciplinizer

// Discussion:
// Happy path is tested using an in memory core data stack while the error paths are "simulated" using a stub NSManagedObjectContextStub
// Probably you could use NSManagedObjectContextStub for happy path testing as well, however you might not be able to instantiate a NSManagedObject subclass
// without a valid context
class CoreDataChallengesGatewayTest: XCTestCase {
    // https://www.martinfowler.com/bliki/TestDouble.html
    var inMemoryCoreDataStack = InMemoryCoreDataStack()
    var managedObjectContextSpy = NSManagedObjectContextSpy()

    var inMemoryCoreDataBooksGateway: CoreDataChallengesGateway {
        return CoreDataChallengesGateway(viewContext: inMemoryCoreDataStack.persistentContainer.viewContext)
    }

    var errorPathCoreDataBooksGateway: CoreDataChallengesGateway {
        return CoreDataChallengesGateway(viewContext: managedObjectContextSpy)
    }

    // MARK: - Tests

    func test_add_with_parameters_getAllChallenges_withParameters_success() {
        // Given
        let challengeParameters = ChallengeParameters.createParameters()

        let addChallengeCompletionHandlerExpectation = expectation(description: "Add challenge completion handler expectation")
        let getChallengesCompletionHandlerExpectation = expectation(description: "Get challenges completion handler expectation")

        // When
        inMemoryCoreDataBooksGateway.add(parameters: challengeParameters) { (result) in
            // Then
            guard let challenge = try? result.get() else {
                XCTFail("Should've saved the book with success")
                return
            }

            assert(challenge: challenge, builtFromParameters: challengeParameters)
            assert(challenge: challenge, wasAddedIn: self.inMemoryCoreDataBooksGateway, expectation: getChallengesCompletionHandlerExpectation)

            addChallengeCompletionHandlerExpectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func test_get_failure() {
        // Given
        let expectedResultToBeReturned: Result<[Challenge], Error> = .failure(CoreError(message: "Failed retrieving challenges from the data base"))
        managedObjectContextSpy.fetchErrorToThrow = NSError.createError(withMessage: "Some core data error")

        let getChallengesCompletionHandlerExpectation = expectation(description: "Fetch challenges completion handler expectation")

        // When
        errorPathCoreDataBooksGateway.getAll { (result) in
            // Then
            switch result {
            case .failure:
                getChallengesCompletionHandlerExpectation.fulfill()
            default:
                XCTFail()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
//
//    func test_add_with_parameters_fails_without_reaching_save() {
//        // Given
//        let expectedResultToBeReturned: Result<Book> = .failure(CoreError(message: "Failed adding the book in the data base"))
//        managedObjectContextSpy.addEntityToReturn = nil
//
//        let addBookCompletionHandlerExpectation = expectation(description: "Add book completion handler expectation")
//
//        // When
//        errorPathCoreDataBooksGateway.add(parameters: AddBookParameters.createParameters()) { (result) in
//            // Then
//            XCTAssertEqual(expectedResultToBeReturned, result, "Failure error wasn't returned")
//            addBookCompletionHandlerExpectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 1, handler: nil)
//    }
//
//    func test_add_with_parameters_fails_when_saving() {
//        // Given
//        let expectedResultToBeReturned: Result<Book> = .failure(CoreError(message: "Failed saving the context"))
//        let addedCoreDataBook = inMemoryCoreDataStack.fakeEntity(withType: CoreDataBook.self)
//        managedObjectContextSpy.addEntityToReturn = addedCoreDataBook
//        managedObjectContextSpy.saveErrorToReturn = NSError.createError(withMessage: "Some core data error")
//
//        let addBookCompletionHandlerExpectation = expectation(description: "Add book completion handler expectation")
//
//        // When
//        errorPathCoreDataBooksGateway.add(parameters: AddBookParameters.createParameters()) { (result) in
//            // Then
//            XCTAssertEqual(expectedResultToBeReturned, result, "Failure error wasn't returned")
//            XCTAssertTrue(self.managedObjectContextSpy.deletedObject! === addedCoreDataBook, "The inserted entity should've been deleted")
//            addBookCompletionHandlerExpectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 1, handler: nil)
//    }
//
//    func test_deleteBook_success() {
//        // Given
//        let addBookParameters1 = AddBookParameters.createParameters()
//        var addedBook1: Book!
//        let addBook1CompletionHandlerExpectation = expectation(description: "Add book completion handler expectation")
//        inMemoryCoreDataBooksGateway.add(parameters: addBookParameters1) { (result) in
//            addedBook1 = try! result.dematerialize()
//            addBook1CompletionHandlerExpectation.fulfill()
//        }
//        waitForExpectations(timeout: 1, handler: nil)
//
//        let addBookParameters2 = AddBookParameters.createParameters()
//        var addedBook2: Book!
//        let addBook2CompletionHandlerExpectation = expectation(description: "Add book completion handler expectation")
//
//        inMemoryCoreDataBooksGateway.add(parameters: addBookParameters2) { (result) in
//            addedBook2 = try! result.dematerialize()
//            addBook2CompletionHandlerExpectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 1, handler: nil)
//
//        let deleteBookCompletionHandlerExpectation = expectation(description: "Delete book completion handler expectation")
//
//        // When
//        inMemoryCoreDataBooksGateway.delete(book: addedBook1) { (result) in
//            XCTAssertEqual(result, Result<Void>.success(()), "Expected a success result")
//            deleteBookCompletionHandlerExpectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 1, handler: nil)
//
//        // Then
//        let fetchBooksCompletionHandlerExpectation = expectation(description: "Fetch books completion handler expectation")
//        inMemoryCoreDataBooksGateway.fetchBooks { (result) in
//            let books = try! result.dematerialize()
//            XCTAssertFalse(books.contains(addedBook1), "The added book should've been deleted")
//            XCTAssertTrue(books.contains(addedBook2), "The second book should be contained")
//            fetchBooksCompletionHandlerExpectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 1, handler: nil)
//    }
//
//    func test_delete_fetch_fails() {
//        // Book
//        let bookToDelete = Book.createBook()
//        let expectedResultToBeReturned: Result<Void> = .failure(CoreError(message: "Failed retrieving books the data base"))
//        managedObjectContextSpy.fetchErrorToThrow = NSError.createError(withMessage: "Some core data error")
//
//        let deleteBookCompletionHandlerExpectation = expectation(description: "Delete book completion handler expectation")
//
//        // When
//        errorPathCoreDataBooksGateway.delete(book: bookToDelete) { (result) in
//            // Then
//            XCTAssertEqual(expectedResultToBeReturned, result, "Failure error wasn't returned")
//            deleteBookCompletionHandlerExpectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 1, handler: nil)
//    }
//
//    func test_delete_save_fails() {
//        // Book
//        let bookToDelete = Book.createBook()
//        let expectedResultToBeReturned: Result<Void> = .failure(CoreError(message: "Failed saving the context"))
//        managedObjectContextSpy.entitiesToReturn = [inMemoryCoreDataStack.fakeEntity(withType: CoreDataBook.self)]
//        managedObjectContextSpy.saveErrorToReturn = NSError.createError(withMessage: "Some core data error")
//
//        let deleteBookCompletionHandlerExpectation = expectation(description: "Delete book completion handler expectation")
//
//        // When
//        errorPathCoreDataBooksGateway.delete(book: bookToDelete) { (result) in
//            // Then
//            XCTAssertEqual(expectedResultToBeReturned, result, "Failure error wasn't returned")
//            deleteBookCompletionHandlerExpectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 1, handler: nil)
//    }
}

// MARK: - Helpers

// https://www.bignerdranch.com/blog/creating-a-custom-xctest-assertion/
fileprivate func assert(challenge: Challenge, builtFromParameters parameters: ChallengeParameters, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(challenge.startDate, parameters.startDate, "startDate mismatch", file: file, line: line)
    XCTAssertEqual(challenge.finishDate, parameters.finishDate, "finishDate mismatch", file: file, line: line)
    XCTAssertEqual(challenge.duration, parameters.duration, "duration mismatch", file: file, line: line)
    XCTAssertEqual(challenge.isPaid, parameters.isPaid, "isPaid mismatch", file: file, line: line)
    XCTAssertEqual(challenge.isSuccess, parameters.isSuccess, "isSuccess mismatch", file: file, line: line)
    XCTAssertEqual(challenge.betId, parameters.betId, "betId mismatch", file: file, line: line)
    XCTAssertTrue(challenge.id != "", "id should not be empty", file: file, line: line)
}

fileprivate func assert(challenge: Challenge, wasAddedIn coreDataBooksGateway: CoreDataChallengesGateway, expectation: XCTestExpectation) {
    coreDataBooksGateway.getAll { (result) in
        guard let challenges = try? result.get() else {
            XCTFail("Should've fetched the challenges with success")
            return
        }

        XCTAssertTrue(challenges.contains(challenge), "Challenge is not found in the returned books")
        XCTAssertEqual(challenges.count, 1, "Challenges array should contain exactly one book")
        expectation.fulfill()
    }
}
