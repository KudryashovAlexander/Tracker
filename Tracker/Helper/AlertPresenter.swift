//
//  AlertPresenter.swift
//  Tracker
//
//  Created by Александр Кудряшов on 24.08.2023.
//

import UIKit


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
    
    func showAlertSheet(model: AlertModel, viewController: UIViewController, completion: @escaping() -> Void) {
        let alert = UIAlertController(title: model.title,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Удалить", style: .default) { _ in
            completion()
        }
        let action2 = UIAlertAction(title: "Отменить", style: .cancel)
        
        alert.addAction(action1)
        alert.addAction(action2)
        
        viewController.present(alert, animated: true)
        
    }
    
}
