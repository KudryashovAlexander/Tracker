//
//  UIKit_ext.swift
//  Tracker
//
//  Created by Александр Кудряшов on 09.09.2023.
//

import UIKit

extension UIButton {
    func customBlackButton(title: String) -> UIButton {
        var button = UIButton()
        button.backgroundColor = .ypBlack
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .yPMedium16
        button.titleLabel?.textAlignment = .center
        return button
    }
}

extension UITextField {
    func customTextField(placeHolder: String) -> UITextField {
        var textField = UITextField()
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 16
        textField.backgroundColor = .ypBackground
        textField.font = .yPRegular17
        textField.textAlignment = .left
        textField.placeholder = placeHolder
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
                
        return textField
    }
}

extension UILabel {
    func attenteionLabel(countSimbol: Int) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .yPRegular17
        label.textColor = .ypRed
        label.text = "Ограничение " + String(countSimbol) + " символов"
        return label
    }
}
