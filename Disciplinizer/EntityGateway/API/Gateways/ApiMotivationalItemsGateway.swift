//
//  ApiMotivationalItemsGateway.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 16.09.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Firebase

protocol ApiMotivationalItemsGatewayProtocol: MotivationalItemsGatewayProtocol {
    
}

extension RemoteConfig: ApiMotivationalItemsGatewayProtocol {
    func getAll(completionHandler: @escaping (Result<[MotivationalItemConfig], Error>) -> Void) {
        let remoteConfig = self
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
                
        remoteConfig.fetchAndActivate { (status, _) in
            switch status {
            case .successFetchedFromRemote, .successUsingPreFetchedData:
                let data = remoteConfig.configValue(forKey: "motivational_items").dataValue
                let motivationalItems = try? JSONDecoder().decode([MotivationalItemConfig].self, from: data)
                                
                completionHandler(.success(motivationalItems ?? []))
            default:
                if let fileURL = Bundle.main.url(forResource: "DefaultPets", withExtension: "json"),
                   let data = try? Data(contentsOf: fileURL),
                    let defaultPets = try? JSONDecoder().decode([MotivationalItemConfig].self, from: data) {
                    print(defaultPets)
                    completionHandler(.success(defaultPets))
                }
            }
        }
    }
    
    func save(motivationalItems: [MotivationalItemConfig], completionHandler: @escaping (Result<Void, Error>) -> Void) {
        return
    }
}

class ApiMotivationalItemsGateway: ApiMotivationalItemsGatewayProtocol {
    let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getAll(completionHandler: @escaping (Result<[MotivationalItemConfig], Error>) -> Void) {
        let motivationalItemsRequest = MotivationalItemsRequest()
        
        apiClient.execute(request: motivationalItemsRequest) { (result: Result<ApiResponse<[MotivationalItemConfig]>, Error>) in
            switch result {
            case .success(let response):
                completionHandler(.success(response.entity))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func save(motivationalItems: [MotivationalItemConfig], completionHandler: @escaping (Result<Void, Error>) -> Void) {
        return
    }
}
