//
//  UIViewController + extension.swift
//  ToDoApp
//
//  Created by Искандер Ситдиков on 20.11.2024.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, actions: [UIAlertAction] = []) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions.isEmpty {
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            actions.forEach { alertController.addAction($0) }
        }
        present(alertController, animated: true)
    }
}
