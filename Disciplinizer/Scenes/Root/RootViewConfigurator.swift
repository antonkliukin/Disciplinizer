//
//  RootViewConfigurator.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 05.10.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Firebase

protocol RootViewConfiguratorProtocol {
    func configure(rootViewController: RootViewController)
}

final class RootViewConfigurator: RootViewConfiguratorProtocol {
    func configure(rootViewController: RootViewController) {
        
        let viewContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let localPersistenceMotivationalItemsGateway = MotivationalItemsCoreDataGateway(viewContext: viewContext)
        
        let apiMotivationalItemsGateway: ApiMotivationalItemsGatewayProtocol = RemoteConfig.remoteConfig()
        
        let motivationalItemsGateway = CacheMotivationalItemsGateway(apiMotivationalItemsGateway: apiMotivationalItemsGateway,
                                                                     localPersistenceMotivationalItemsGateway: localPersistenceMotivationalItemsGateway)
        
        let displayMotivationalItemsUseCase = DisplayMotivationalItemsUseCase(itemsGateway: motivationalItemsGateway)
        
        let presenter = RootViewPresenter(view: rootViewController,
                                          displayMotivationalItemsUseCase: displayMotivationalItemsUseCase)
        
        rootViewController.presenter = presenter
    }
}
