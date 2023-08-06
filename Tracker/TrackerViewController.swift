//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 06.08.2023.
//

import UIKit
class TrackerViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationSupport()

        
    }
    
    private func navigationSupport() {
        if let navBar = navigationController?.navigationBar {
            
            let leftButton = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(add))
            navBar.topItem?.leftBarButtonItem = leftButton
            
            let datePicker = UIDatePicker()
            
            datePicker.preferredDatePickerStyle = .compact
            datePicker.datePickerMode = .date
            
            datePicker.locale = Locale(identifier: "ru_RU")
//            datePicker.date.formatted() = "dd MM YYYY"
            
            let rightButton = UIBarButtonItem(customView: datePicker)
            navBar.topItem?.rightBarButtonItem = rightButton
            
        }
        self.navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    @objc
    private func add() {
        //TODO: - Метод перехода на вью с доабвление новой привычки или неругулярного события
    }
    
}
