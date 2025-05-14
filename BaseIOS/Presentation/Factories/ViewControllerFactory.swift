//
//  ViewControllerFactory.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/6/25.
//

import UIKit

enum ViewControllerType {
    case main
    case detail
}

final class ViewControllerFactory {
    static func makeViewController(coordinator: Coordinator, type: ViewControllerType) -> UIViewController {
        switch type {
        case .main:
            let viewModel = ViewModel()
            return ViewController(coordinator: coordinator as! MainCoordinator, viewModel: viewModel)
        case .detail:
            let viewModel = DetailViewModel()
            return DetailViewController(coordinator: coordinator as! DetailCoordinator, viewModel: viewModel)
        }
       
    }
}
