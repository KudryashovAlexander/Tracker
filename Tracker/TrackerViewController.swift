//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 06.08.2023.
//

import UIKit
class TrackerViewController: UIViewController {
    
    private let sController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationSupport()

        
    }
    
    private func navigationSupport() {
        guard let navControl = navigationController else { return }
        let navBar = navControl.navigationBar
        
        let leftButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(add))
        leftButton.tintColor = .ypBlack
        navBar.topItem?.leftBarButtonItem = leftButton
        
        let datePicker = UIDatePicker()
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        
        datePicker.locale = Locale(identifier: "ru_RU")
        //            datePicker.date.formatted() = "dd MM YYYY"
        
        let rightButton = UIBarButtonItem(customView: datePicker)
        navBar.topItem?.rightBarButtonItem = rightButton
        
        
        self.navigationItem.title = "Трекеры"
        navBar.prefersLargeTitles = true
        
        
        sController.hidesNavigationBarDuringPresentation = false
        
        
        sController.searchBar.searchTextField.placeholder = "Поиск"
        self.navigationItem.searchController = sController
        
    }
    
    @objc
    private func add() {
        //TODO: - Метод перехода на вью с доабвление новой привычки или неругулярного события
    }
    
}
