//
//  AlertPresenter.swift
//  Tracker
//
//  Created by Александр Кудряшов on 24.08.2023.
//

import UIKit


final class AlertPresenter {
    
    func showAlert(model: AlertModel, viewController: UIViewController, completion: @escaping () -> Void) {
        
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonTitle, style: .default) { _ in
            completion()
        }
        
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func showAlertSheet(model: AlertModel, viewController: UIViewController, completion: @escaping() -> Void) {
        let alert = UIAlertController(title: model.title,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: String().buttonDelete, style: .destructive) { _ in
            completion()
        }
        let action2 = UIAlertAction(title: String().buttonCansel, style: .cancel)
        
        alert.addAction(action1)
        alert.addAction(action2)
        
        viewController.present(alert, animated: true)
        
    }
    
}
