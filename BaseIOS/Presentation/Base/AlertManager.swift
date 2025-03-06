//
//  AlertManager.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/6/25.
//

import UIKit

class AlertManager {
    static func showAlert(
        on viewController: UIViewController,
        title: String,
        message: String,
        actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default)]
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        viewController.present(alert, animated: true)
    }

    static func showErrorAlert(on viewController: UIViewController, message: String) {
        showAlert(on: viewController, title: "Lỗi", message: message)
    }

    static func showConfirmation(
        on viewController: UIViewController,
        title: String,
        message: String,
        confirmTitle: String = "OK",
        cancelTitle: String = "Hủy",
        confirmHandler: (() -> Void)? = nil
    ) {
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            confirmHandler?()
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
        showAlert(on: viewController, title: title, message: message, actions: [confirmAction, cancelAction])
    }
}
