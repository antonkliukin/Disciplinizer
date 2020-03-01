//
//  LocalPersistanceGateway.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 15.02.2020.
//  Copyright © 2020 FutureCompanyName. All rights reserved.
//

import CoreData

protocol LocalPersistenceChallengesGatewayProtocol: ChallengesGatewayProtocol {
    func save(challenges: [Challenge])

    func add(challenge: Challenge)
}

class CoreDataChallengesGateway: LocalPersistenceChallengesGatewayProtocol {
    let viewContext: NSManagedObjectContextProtocol

    init(viewContext: NSManagedObjectContextProtocol) {
        self.viewContext = viewContext
    }

    // MARK: - ChallengesGateway

    func getChallenges(completionHandler: @escaping (Result<[Challenge], Error>) -> Void) {
        if let coreDataChallenges = try? viewContext.allEntities(withType: CDChallenge.self) {
            let challenges = coreDataChallenges.map { $0.challenge }
            completionHandler(.success(challenges))
        } else {
            completionHandler(.failure(CoreError(message: "Failed retrieving challenges from the data base")))
        }
    }

    func add(parameters: AddChallengeParameters, completionHandler: @escaping (Result<Challenge, Error>) -> Void) {
        guard let coreDataChallenge = viewContext.addEntity(withType: CDChallenge.self) else {
            completionHandler(.failure(CoreError(message: "Failed adding the challenge in the data base")))
            return
        }

        coreDataChallenge.populate(with: parameters)

        do {
            try viewContext.save()
            completionHandler(.success(coreDataChallenge.challenge))
        } catch {
            viewContext.delete(coreDataChallenge)
            completionHandler(.failure(CoreError(message: "Failed saving the context")))
        }
    }

    func delete(challenge: Challenge, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        let predicate = NSPredicate(format: "id==%@", challenge.id)

        if let coreDataChallenges = try? viewContext.allEntities(withType: CDChallenge.self, predicate: predicate),
            let coreDataChallenge = coreDataChallenges.first {
            viewContext.delete(coreDataChallenge)
        } else {
            completionHandler(.failure(CoreError(message: "Failed retrieving challenges the data base")))
            return
        }

        do {
            try viewContext.save()
            completionHandler(.success(()))
        } catch {
            completionHandler(.failure(CoreError(message: "Failed saving the context")))
        }

    }

    func deleteAll(completionHandler: @escaping DeleteChallengeEntityGatewayCompletionHandler) {
        if let coreDataChallenges = try? viewContext.allEntities(withType: CDChallenge.self) {
            coreDataChallenges.forEach { viewContext.delete($0) }
        } else {
           completionHandler(.failure(CoreError(message: "Failed retrieving challenges the data base")))
            return
        }

        do {
            try viewContext.save()
            completionHandler(.success(()))
        } catch {
            completionHandler(.failure(CoreError(message: "Failed deleting all challenges from the data base")))
        }
    }

    // MARK: - LocalPersistenceBooksGateway

    func save(challenges: [Challenge]) {
        // Save challenges to core data. Depending on your specific need this might need to be turned into some kind of merge mechanism.
    }

    func add(challenge: Challenge) {
        // Add challenge. Usually you could call this after the entity was successfully added on the API side or you could use the save method.
    }
}
