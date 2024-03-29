//
//  LocalPersistanceGateway.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.02.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol LocalPersistenceChallengesGatewayProtocol: ChallengesGatewayProtocol {
    //func update(challenge: Challenge)
}

class CoreDataChallengesGateway: LocalPersistenceChallengesGatewayProtocol {
    let viewContext: NSManagedObjectContextProtocol

    init(viewContext: NSManagedObjectContextProtocol) {
        self.viewContext = viewContext
    }

    // MARK: - ChallengesGateway

    func getLast(completionHandler: @escaping (_ challenge: Result<Challenge?, Error>) -> Void) {
        if let coreDataChallenges = try? viewContext.allEntities(withType: CDChallenge.self) {
            let lastCoreDataChallenge = coreDataChallenges.last
            completionHandler(.success(lastCoreDataChallenge?.challenge))
        } else {
            completionHandler(.failure(CoreError(message: "Failed retrieving last challenge from the data base")))
            return
        }
    }

    func getAll(completionHandler: @escaping (_ challenges: Result<[Challenge], Error>) -> Void) {
        if let coreDataChallenges = try? viewContext.allEntities(withType: CDChallenge.self) {
            let challenges = coreDataChallenges.map { $0.challenge }
            completionHandler(.success(challenges))
        } else {
            completionHandler(.failure(CoreError(message: "Failed retrieving challenges from the data base")))
        }
    }

    func add(parameters: ChallengeParameters, completionHandler: (_ challenge: Result<Challenge, Error>) -> Void) {
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

    func update(challenge: Challenge, completionHandler: @escaping (_ challenge: Result<Challenge, Error>) -> Void) {
        let idPredicate = NSPredicate(format: "id = %@", challenge.id)

        if let challengeFetchResult = try? viewContext.allEntities(withType: CDChallenge.self, predicate: idPredicate),
           let challengeToUpdate = challengeFetchResult.first {

            challengeToUpdate.pupulate(with: challenge)

            do {
                try viewContext.save()
                completionHandler(.success(challengeToUpdate.challenge))
            } catch {
                viewContext.delete(challengeToUpdate)
                completionHandler(.failure(CoreError(message: "Failed saving the context")))
            }

        } else {
            completionHandler(.failure(CoreError(message: "Failed finding challenge with id \(challenge.id)")))
        }
    }

    func delete(challenge: Challenge, completionHandler: (_ challenge: Result<Void, Error>) -> Void) {
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

    func deleteAll(completionHandler: @escaping (_ challenge: Result<Void, Error>) -> Void) {
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
}
