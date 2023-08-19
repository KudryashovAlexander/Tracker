//
//  TrackerConfigurationViewController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 16.08.2023.
//

import UIKit

class TrackerConfigurationViewController: UIViewController {
    
    var navName = String()
    var isRegular: Bool = false
    
    private var scrollView = UIScrollView()
    
    private let nameTrackerConteiner = UIView()
    
    private let nameTrackerTextField = UITextField()
    
    private var attentionLabel: UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .yPRegular17
        label.textColor = .ypRed
        label.text = "Ограничение 38 символов"
        label.isEnabled = false
        return label
    }
    
    private let supportTrackerConteiner = UIView()
    
    private let categoryButton = UIButton()
    private let scheduleButton = UIButton()
    
    //private var emojieContentView = UICollectionView()
    //private var colorContentView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        self.navigationItem.title = navName
        
        nameTrackerConteinerSupport()
        nameTrackerTextFieldSupport()
        
        layoutSupport()
    }
    
    private func layoutSupport() {
        
        view.addSubview(nameTrackerConteiner)
        nameTrackerConteiner.translatesAutoresizingMaskIntoConstraints = false
        
        nameTrackerConteiner.addSubview(nameTrackerTextField)
        nameTrackerTextField.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            nameTrackerConteiner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTrackerConteiner.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            nameTrackerConteiner.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,constant: -16),
            nameTrackerConteiner.heightAnchor.constraint(equalToConstant: 75),
            
            
            nameTrackerTextField.topAnchor.constraint(equalTo: nameTrackerConteiner.topAnchor),
            nameTrackerTextField.leftAnchor.constraint(equalTo: nameTrackerConteiner.leftAnchor),
            nameTrackerTextField.rightAnchor.constraint(equalTo: nameTrackerConteiner.rightAnchor),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75)
            
        ])
        
    }
    
    //Вью для ввода
    private func nameTrackerConteinerSupport() {
        nameTrackerConteiner.backgroundColor = .white
    }
    
    //texfield для ввода
    private func nameTrackerTextFieldSupport() {
        nameTrackerTextField.layer.masksToBounds = true
        nameTrackerTextField.layer.cornerRadius = 16
        nameTrackerTextField.backgroundColor = .ypBackground
        nameTrackerTextField.font = .yPRegular17
        nameTrackerTextField.textAlignment = .left
        nameTrackerTextField.placeholder = "Введите название трекера"
        
        nameTrackerTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: nameTrackerTextField.frame.height))
        nameTrackerTextField.leftViewMode = .always
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: nameTrackerTextField.frame.height))
    
        let button = UIButton(type: .custom)
        button.frame.size = CGSize(width: 41, height: 41)
        button.center.y = rightView.center.y
        let image = UIImage(named: "textfieldCansel_button")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(removeText), for: .touchUpInside)
//        button.sizeToFit()
        rightView.addSubview(button)


        nameTrackerTextField.rightView = rightView
        nameTrackerTextField.rightViewMode = .whileEditing
    }
    
    @objc
    private func removeText() {
        nameTrackerTextField.text = ""
    }
    
    
    private func attentionLabelSupport(_ textCount: Int) {
        
        if textCount > 37 {
            
            attentionLabel.isEnabled = true
            attentionLabel.translatesAutoresizingMaskIntoConstraints = false

            nameTrackerConteiner.addSubview(attentionLabel)
            
            NSLayoutConstraint.activate([
                nameTrackerConteiner.heightAnchor.constraint(equalToConstant: 75 + 38),

                attentionLabel.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 8),
                attentionLabel.bottomAnchor.constraint(equalTo: nameTrackerConteiner.bottomAnchor,constant: -8),
                attentionLabel.widthAnchor.constraint(equalTo: nameTrackerConteiner.widthAnchor)
            
            ])

        } else {
            attentionLabel.isEnabled = false
        }
    }
    

}
