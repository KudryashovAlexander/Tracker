//
//  TrackerConfigurationViewController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 16.08.2023.
//

import UIKit

protocol TrackerConfigurationViewControllerDelegate: AnyObject {
    func createTracker(_ newTracker: Tracker, category: TrackerCategory)
}


final class TrackerConfigurationViewController: UIViewController {
    
    var navName = String()
    var isRegular: Bool = false
        
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhite
        scrollView.frame = view.bounds
        scrollView.contentSize = contenSize
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.frame.size = contenSize
        view.backgroundColor = .ypWhite
        return view
    }()
    
    private var contenSize: CGSize{
        return CGSize(width: view.frame.width, height: 841)
    }
    
    private let nameTrackerConteiner = UIView()
    
    private let nameTrackerTextField = UITextField().customTextField(placeHolder: "Введите название трекера")
    
    private var attentionLabel = UILabel().attenteionLabel(countSimbol: 38)
    
    private var propertyTracker = ["Категория","Расписание"]
    
    private let propertyTableViewConteiner = UIView()
    private let propertyTableView = UITableView()
    
    private var emojieCollectionView = EmojieView()
    private let emojieNameLabel = UILabel()
    
    private var colorCollectionView = ColorView()
    private let colorNameLabel = UILabel()
    
    private let canselButton = UIButton().customRedButton(title: "Отменить")
    private let createButton = UIButton().customBlackButton(title: "Создать")
    
    var schedule = Schedule()
    
    private let alertPresenter = AlertPresener()
    
    var delegate: TrackerConfigurationViewControllerDelegate?
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        self.navigationItem.title = navName
        
        if isRegular == false {
            propertyTracker.removeLast()
        }
        
        propertyTableView.delegate = self
        propertyTableView.dataSource = self
        nameTrackerTextField.delegate = self
        
        nameTrackerConteinerSupport()
        nameTrackerTextFieldSupport()
        
        propertyTableViewConteinerSupport()
        propertyTableViewSupport()
        
        emojieNameLabelSupport()
        colorNameLabelSupport()
                
        layoutSupport()
    }
    
    private func layoutSupport() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        nameTrackerConteiner.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameTrackerConteiner)
        
        nameTrackerTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTrackerConteiner.addSubview(nameTrackerTextField)
        
        propertyTableViewConteiner.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(propertyTableViewConteiner)
        
        propertyTableView.translatesAutoresizingMaskIntoConstraints = false
        propertyTableViewConteiner.addSubview(propertyTableView)
        
        emojieCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojieCollectionView)
        
        emojieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojieNameLabel)
        
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorCollectionView)
        
        colorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorNameLabel)
        
        canselButton.addTarget(self, action: #selector(canselPress), for: .touchUpInside)
        canselButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(canselButton)
        
        createButton.addTarget(self, action: #selector(createPress), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            
            nameTrackerConteiner.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nameTrackerConteiner.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32),
            nameTrackerConteiner.heightAnchor.constraint(equalToConstant: 75),
            nameTrackerConteiner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameTrackerTextField.topAnchor.constraint(equalTo: nameTrackerConteiner.topAnchor),
            nameTrackerTextField.leftAnchor.constraint(equalTo: nameTrackerConteiner.leftAnchor),
            nameTrackerTextField.rightAnchor.constraint(equalTo: nameTrackerConteiner.rightAnchor),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            
            propertyTableViewConteiner.topAnchor.constraint(equalTo: nameTrackerConteiner.bottomAnchor, constant: 24),
            propertyTableViewConteiner.widthAnchor.constraint(equalTo: nameTrackerConteiner.widthAnchor),
            propertyTableViewConteiner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            propertyTableViewConteiner.heightAnchor.constraint(equalToConstant: CGFloat(75 * propertyTracker.count)),
            
            propertyTableView.topAnchor.constraint(equalTo: propertyTableViewConteiner.topAnchor),
            propertyTableView.bottomAnchor.constraint(equalTo: propertyTableViewConteiner.bottomAnchor),
            propertyTableView.leftAnchor.constraint(equalTo: propertyTableViewConteiner.leftAnchor),
            propertyTableView.rightAnchor.constraint(equalTo: propertyTableViewConteiner.rightAnchor),
            
            emojieCollectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojieCollectionView.widthAnchor.constraint(equalToConstant: contentView.frame.width - 16 * 2),
            emojieCollectionView.topAnchor.constraint(equalTo: propertyTableViewConteiner.bottomAnchor, constant: 74),
            emojieCollectionView.heightAnchor.constraint(equalToConstant: 52 * 3),
            
            emojieNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 28),
            emojieNameLabel.bottomAnchor.constraint(equalTo: emojieCollectionView.topAnchor),
            
            colorCollectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorCollectionView.widthAnchor.constraint(equalToConstant: contentView.frame.width - 16 * 2),
            colorCollectionView.topAnchor.constraint(equalTo: emojieCollectionView.bottomAnchor, constant: 58),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 52 * 3),
            
            colorNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 28),
            colorNameLabel.bottomAnchor.constraint(equalTo: colorCollectionView.topAnchor),
            
            canselButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            canselButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            canselButton.widthAnchor.constraint(equalToConstant: contentView.frame.width / 2 - 20 - 4),
            canselButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            createButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            createButton.widthAnchor.constraint(equalToConstant: contentView.frame.width / 2 - 20 - 4),
            createButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        
    }
    
    private func nameTrackerConteinerSupport() {
        nameTrackerConteiner.backgroundColor = .white
    }
    
    private func nameTrackerTextFieldSupport() {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: nameTrackerTextField.frame.height))
    
        let button = UIButton(type: .custom)
        button.frame.size = CGSize(width: 41, height: 41)
        button.center.y = rightView.center.y
        let image = UIImage(named: "textfieldCansel_button")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(removeText), for: .touchUpInside)
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

        propertyTableView.tableHeaderView = UIView()
    }
    
    private func propertyTableViewSupport() {
        
        propertyTableView.register(NewTrackerTableViewCell.self, forCellReuseIdentifier: NewTrackerTableViewCell.cellIdentifier)
        propertyTableView.isScrollEnabled = false
        propertyTableView.separatorInset.left = 16
        propertyTableView.separatorInset.right = 16
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
    
    @objc
    private func canselPress() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func createPress(){
        createButton.backgroundColor = .ypGray
        
        if let name = nameTrackerTextField.text {
            if !name.isEmpty {
                let tracker = Tracker(name: name, color: colorCollectionView.selectedColor, emojie: emojieCollectionView.selectedEmojie, schedule: schedule)
                
                //MARK: - ЗДЕСЬ ЗАДАЕТСЯ КАСТОМНАЯ КАТЕГОРИЯ
                let trackerCategory = TrackerCategory(name: "Тестовая", trackers: [tracker])
                
                guard let window = UIApplication.shared.windows.first else {
                    fatalError("Invalid Configuration") }

                let tabBar = TabBarController()
                self.delegate = tabBar.trackerViewController
                delegate?.createTracker(tracker, category: trackerCategory)
                
                window.rootViewController = tabBar
                
            } else {
                alertPresenter.showAlert(message: "наименование трекера", viewController: self) {
                    self.createButton.backgroundColor = .ypBlack
                }
            }
        }
    }

}
//MARK: - Extension UITexFieldDelegate
extension TrackerConfigurationViewController: UITextFieldDelegate {
    //Метод отслеживающий изменения textField.text
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
        newTrackerCell.propertyName = propertyTracker[indexPath.row]
        if indexPath.row == propertyTracker.count {
            newTrackerCell.separatorInset.left = tableView.frame.maxX
        }
        newTrackerCell.selectionStyle = .none
        newTrackerCell.backgroundColor = .ypBackground
        return newTrackerCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            createCategoryViewController()
        }
        
        if indexPath.row == 1 {
            createScheduleViewController()
        }
        
    }
    
    private func createScheduleViewController() {
        let vc = ScheduleViewController()
        vc.schedule = schedule
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    private func createCategoryViewController() {
        let vc = CategoryViewController()
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
}

//MARK: - Extension ScheduleViewControllerProtocol
extension TrackerConfigurationViewController: ScheduleViewControllerProtocol {
    func updateSchedule(_ newSchedule: Schedule) {
        schedule = newSchedule
    }
    
}
