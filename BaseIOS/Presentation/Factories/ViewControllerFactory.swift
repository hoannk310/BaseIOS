//
//  ViewControllerFactory.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/6/25.
//

final class ViewControllerFactory {
    static func makeMainViewController(coordinator: MainCoordinator) -> ViewController {
        let viewModel = ViewModel()
        return ViewController(coordinator: coordinator, viewModel: viewModel)
    }
    
    static func makeDetailViewController(coordinator: DetailCoordinator) -> DetailViewController {
        let viewModel = DetailViewModel()
        return DetailViewController(coordinator: coordinator, viewModel: viewModel)
    }
}
