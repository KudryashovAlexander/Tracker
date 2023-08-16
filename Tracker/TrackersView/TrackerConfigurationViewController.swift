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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        self.navigationItem.title = navName
    }
    

}
