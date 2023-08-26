//
//  AlertPresenter.swift
//  Tracker
//
//  Created by Александр Кудряшов on 24.08.2023.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonTitle: String
}

final class AlertPresener {
    
    private let defaultAlert = AlertModel(title: "Не хватает параметров",
                                         message: "Введите: ",
                                         buttonTitle: "OK")
    
    
    func showAlert(message: String, viewController: UIViewController, completion: @escaping () -> Void) {
        
        let alert = UIAlertController(title: defaultAlert.title,
                                      message: defaultAlert.message + message,
                                      preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: defaultAlert.buttonTitle, style: .default) { _ in
            completion()
        }
        alert.addAction(action)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
