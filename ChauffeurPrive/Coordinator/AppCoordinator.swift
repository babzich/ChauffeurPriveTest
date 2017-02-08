//
//  AppCoordinator.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 08/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    weak var navigationController: UINavigationController? { get }
    
    func start() -> Void
    func stop() -> Void
}

final class AppCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    var childCoordinators: [Coordinator] = []
    
    // MARK: Initializer
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    // MARK: Coordinator
    
    func start() {
        let mapCoordinator = MapCoordinator(navigationController: navigationController)
        mapCoordinator.start()
        childCoordinators.append(mapCoordinator)
    }
    
    func stop() {
        
    }
    
}
