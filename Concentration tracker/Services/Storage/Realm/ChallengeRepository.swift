//
//  HistoryStorage.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 26.10.2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
//

import RealmSwift

protocol ChallengeStorageProtocol {
    func save(_ challenge: Challenge) -> Result<Void, ChallengeReposotoryError>
    func getAll() -> Result<[Challenge], ChallengeReposotoryError>
    func get(withId id: String) -> Result<Challenge, ChallengeReposotoryError>
    func getLastFailed() -> Result<Challenge, ChallengeReposotoryError>
    func update(applyChanges: (() -> Void)?) -> Result<Void, ChallengeReposotoryError>
    func deleteAll() -> Result<Void, ChallengeReposotoryError>
}

enum ChallengeReposotoryError: Error {
    case savingError
    case retrievingError
    case deletingError
    case updatingError

    var localizedDescription: String {
        switch self {
        case .savingError: return "savingError"
        case .retrievingError: return "retrievingError"
        case .deletingError: return "deletingError"
        case .updatingError: return "updatingError"
        }
    }
}

final class ChallengeRepository: ChallengeStorageProtocol {
    // swiftlint:disable:next force_try
    let realm = try! Realm()

    func save(_ challenge: Challenge) -> Result<Void, ChallengeReposotoryError> {
//        if let challenge = challenge as? ChallengeRealm {
//            // let id = (realm.objects(ChallengeRealm.self).max(ofProperty: "id") as Int? ?? 0) + 1
//            challenge.id = 0
//
//            do {
//                try realm.write {
//                    realm.add(challenge)
//                }
//            } catch {
//                return .failure(.savingError)
//            }
//
//            return .success
//        }

        return .failure(.savingError)
    }

    func getAll() -> Result<[Challenge], ChallengeReposotoryError> {
        //return .success(Array(realm.objects(ChallengeRealm.self)))

        return .failure(.retrievingError)
    }

    func get(withId id: String) -> Result<Challenge, ChallengeReposotoryError> {
//        if let challenge = realm.object(ofType: ChallengeRealm.self, forPrimaryKey: id) {
//            return .success(challenge)
//        } else {
//            return .failure(.retrievingError)
//        }

        return .failure(.retrievingError)
    }

    func getLastFailed() -> Result<Challenge, ChallengeReposotoryError> {
//        if let challenge = realm.objects(ChallengeRealm.self).filter("isSuccess = false").last {
//            return .success(challenge)
//        } else {
//            return .failure(.retrievingError)
//        }

        return .failure(.retrievingError)
    }

    func deleteAll() -> Result<Void, ChallengeReposotoryError> {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            return .failure(.deletingError)
        }

        return .success
    }

    func update(applyChanges: (() -> Void)?) -> Result<Void, ChallengeReposotoryError> {
        do {
            try realm.write {
                applyChanges?()
            }
        } catch {
            return .failure(.updatingError)
        }

        return .success
    }
}
