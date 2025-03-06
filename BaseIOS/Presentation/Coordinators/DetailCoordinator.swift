//
//  DetailCoordinator.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/6/25.
//

import UIKit

class DetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("deinit \(String(describing: self))")
    }
    
    func start() {
        let viewController = ViewControllerFactory.makeDetailViewController(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showMain() {
        let coordinator = MainCoordinator(navigationController: navigationController)
        coordinator.start()
    }
    
    func navigateBack() {
        navigationController.popViewController(animated: true)
    }
}
