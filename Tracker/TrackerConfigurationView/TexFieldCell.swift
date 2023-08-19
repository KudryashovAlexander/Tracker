//
//  TexFieldCell.swift
//  Tracker
//
//  Created by Александр Кудряшов on 19.08.2023.
//

import UIKit

class TextFielCell: GeneralTableViewCell {
    
    static let TextFielDCellidetifier = "TextFielDCellidetifier"
    
    private let nameTrackerTextField = UITextField()
    
    private func nameTrackerTextFieldSupport() {
        nameTrackerTextField.backgroundColor = .ypBackground
        nameTrackerTextField.font = .yPRegular17
        nameTrackerTextField.textAlignment = .left
        nameTrackerTextField.placeholder = "Введите название трекера"
        let button = UIButton(type: .custom)
        let image = UIImage(named: "textfieldCansel_button")
        button.sizeToFit()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(removeText), for: .touchUpInside)
        nameTrackerTextField.rightView = button
        nameTrackerTextField.rightViewMode = .whileEditing
    }
    
    @objc
    private func removeText() {
        nameTrackerTextField.text = ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewCell.addSubview(nameTrackerTextField)
        
        viewCell.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTrackerTextField.topAnchor.constraint(equalTo: viewCell.topAnchor),
            nameTrackerTextField.bottomAnchor.constraint(equalTo: viewCell.bottomAnchor),
            nameTrackerTextField.leftAnchor.constraint(equalTo: viewCell.leftAnchor),
            nameTrackerTextField.rightAnchor.constraint(equalTo: viewCell.rightAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
