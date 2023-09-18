//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 06.08.2023.
//

import UIKit

final class StatisticViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = String().mainStatistic
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
