//
//  MainCoordinator.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/6/25.
//

import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("deinit \(String(describing: self))")
    }
    
    func start() {
        let viewController = ViewControllerFactory.makeMainViewController(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showDetail() {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController)
        detailCoordinator.start()
    }
    
    func navigateBack() {
        navigationController.popViewController(animated: true)
    }
}
