//
//  NSManagedObjectContextSpy.swift
//  ConcentrationTrackerTests
//
//  Created by Anton Kliukin on 02.03.2020.
//  Copyright © 2020 FutureCompanyName. All rights reserved.
//

import CoreData

@testable import Concentration_tracker

class NSManagedObjectContextSpy: NSManagedObjectContextProtocol {
    var fetchErrorToThrow: Error?
    var entitiesToReturn: [Any]?
    var addEntityToReturn: Any?
    var saveErrorToReturn: Error?
    var deletedObject: NSManagedObject?

    func allEntities<T: NSManagedObject>(withType type: T.Type) throws -> [T] {
        return try allEntities(withType: type, predicate: nil)
    }

    func allEntities<T: NSManagedObject>(withType type: T.Type, predicate: NSPredicate?) throws -> [T] {
        if let fetchErrorToThrow = fetchErrorToThrow {
            throw fetchErrorToThrow
        } else {
            // swiftlint:disable:next force_cast
            return entitiesToReturn as! [T]
        }
    }

    func addEntity<T: NSManagedObject>(withType type: T.Type) -> T? {
        return addEntityToReturn as? T
    }

    func save() throws {
        if let saveErrorToReturn = saveErrorToReturn {
            throw saveErrorToReturn
        }
    }

    func delete(_ object: NSManagedObject) {
        deletedObject = object
    }
}
