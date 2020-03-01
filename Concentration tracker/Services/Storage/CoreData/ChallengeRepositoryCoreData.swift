//
//  ChallengeRepositoryCoreData.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 11.02.2020.
//  Copyright © 2020 FutureCompanyName. All rights reserved.
//

import CoreData

class PersistentContainer: NSPersistentContainer {
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}

final class ChallengeRepositoryCoreData {
    static var persistentContainer: PersistentContainer = {
        let container = PersistentContainer(name: "DataBaseSchema")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    func save(_ challenge: ChallengeModelProtocol) -> Result<Void, ChallengeReposotoryError> {
        let managedContext = ChallengeRepositoryCoreData.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CDChallenge", in: managedContext)!
        let challenge = NSManagedObject(entity: entity, insertInto: managedContext)

        challenge.setValue("", forKey: "title")
        challenge.setValue(UUID(), forKey: "id")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return .failure(.savingError)
        }

        return .success
    }

    func getAll() -> Result<[NSManagedObject], ChallengeReposotoryError> {
        let managedContext = ChallengeRepositoryCoreData.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDChallenge")
        var challenges: [NSManagedObject] = []

        do {
            challenges = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetched. \(error), \(error.userInfo)")
            return .failure(.retrievingError)

        }

        return .success(challenges)
    }
}
