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
    
    private var propertyTracker = ["Категория","Расписание"]
    
    private let propertyTableViewConteiner = UIView()
    private let propertyTableView = UITableView()
    
    private var emojieCollectionView = EmojieView()
    private let emojieNameLabel = UILabel()
    
    private var colorCollectionView = ColorView()
    private let colorNameLabel = UILabel()
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()

        
        view.backgroundColor = .ypWhite
        self.navigationItem.title = navName
        
        if isRegular == false {
            propertyTracker.removeLast()
        }
        
        propertyTableView.delegate = self
        propertyTableView.dataSource = self
        
        nameTrackerConteinerSupport()
        nameTrackerTextFieldSupport()
        
        propertyTableViewConteinerSupport()
        propertyTableViewSupport()
        
        emojieNameLabelSupport()
        colorNameLabelSupport()
                
        layoutSupport()
    }
    
    private func layoutSupport() {
        
        nameTrackerConteiner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTrackerConteiner)
        
        nameTrackerTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTrackerConteiner.addSubview(nameTrackerTextField)
        
        propertyTableViewConteiner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(propertyTableViewConteiner)
        
        propertyTableView.translatesAutoresizingMaskIntoConstraints = false
        propertyTableViewConteiner.addSubview(propertyTableView)
        
        emojieCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emojieCollectionView)
        
        emojieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emojieNameLabel)
        
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorCollectionView)
        
        colorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorNameLabel)
        
        NSLayoutConstraint.activate([
            nameTrackerConteiner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTrackerConteiner.widthAnchor.constraint(equalTo:view.widthAnchor, constant: -32),
            nameTrackerConteiner.heightAnchor.constraint(equalToConstant: 75),
            nameTrackerConteiner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            nameTrackerTextField.topAnchor.constraint(equalTo: nameTrackerConteiner.topAnchor),
            nameTrackerTextField.leftAnchor.constraint(equalTo: nameTrackerConteiner.leftAnchor),
            nameTrackerTextField.rightAnchor.constraint(equalTo: nameTrackerConteiner.rightAnchor),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            
            propertyTableViewConteiner.topAnchor.constraint(equalTo: nameTrackerConteiner.bottomAnchor, constant: 24),
            propertyTableViewConteiner.widthAnchor.constraint(equalTo: nameTrackerConteiner.widthAnchor),
            propertyTableViewConteiner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            propertyTableViewConteiner.heightAnchor.constraint(equalToConstant: CGFloat(75 * propertyTracker.count)),
            
            propertyTableView.topAnchor.constraint(equalTo: propertyTableViewConteiner.topAnchor),
            propertyTableView.bottomAnchor.constraint(equalTo: propertyTableViewConteiner.bottomAnchor),
            propertyTableView.leftAnchor.constraint(equalTo: propertyTableViewConteiner.leftAnchor),
            propertyTableView.rightAnchor.constraint(equalTo: propertyTableViewConteiner.rightAnchor),
            
            emojieCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojieCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width - 16 * 2),
            emojieCollectionView.topAnchor.constraint(equalTo: propertyTableViewConteiner.bottomAnchor, constant: 50),
            emojieCollectionView.heightAnchor.constraint(equalToConstant: 52 * 3),
            
            emojieNameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 28),
            emojieNameLabel.bottomAnchor.constraint(equalTo: emojieCollectionView.topAnchor),
            
            colorCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width - 16 * 2),
            colorCollectionView.topAnchor.constraint(equalTo: emojieCollectionView.bottomAnchor, constant: 34),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 52 * 3),
            
            colorNameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 28),
            colorNameLabel.bottomAnchor.constraint(equalTo: colorCollectionView.topAnchor),
    
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
    
    
    private func propertyTableViewConteinerSupport() {
        propertyTableViewConteiner.backgroundColor = .ypBackground
        propertyTableViewConteiner.layer.masksToBounds = true
        propertyTableViewConteiner.layer.cornerRadius = 16
        propertyTableView.separatorInset.left = 16
        propertyTableView.separatorInset.right = 16
        propertyTableView.tableHeaderView = UIView()
    }
    
    private func propertyTableViewSupport() {
        
        propertyTableView.register(NewTrackerTableViewCell.self, forCellReuseIdentifier: NewTrackerTableViewCell.cellIdentifier)
        propertyTableView.isScrollEnabled = false
        propertyTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine

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
    
    private func emojieNameLabelSupport() {
        emojieNameLabel.text = EmojieCollection().name
        emojieNameLabel.font = .yPBold19
        emojieNameLabel.textAlignment = .left
    }
    
    private func colorNameLabelSupport() {
        colorNameLabel.text = ColorCollection().name
        colorNameLabel.font = .yPBold19
        colorNameLabel.textAlignment = .left
    }
    

}

//MARK: - Extension TableView
extension TrackerConfigurationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return propertyTracker.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewTrackerTableViewCell.cellIdentifier, for: indexPath)
        guard let newTrackerCell = cell as? NewTrackerTableViewCell else {
             return UITableViewCell()
        }
//        newTrackerCell.selectedProperty = "Привет"
        newTrackerCell.propertyName = propertyTracker[indexPath.row]
        if indexPath.row == propertyTracker.count {
            newTrackerCell.separatorInset.left = tableView.frame.maxX
        }
        newTrackerCell.backgroundColor = .ypBackground
        return newTrackerCell
    }
    
    
}
