//
//  TabBarController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 06.08.2023.
//

import UIKit
class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        let trackerViewController = TrackerViewController()
        let statisticViewController = StatisticViewController()
        
        let trackerNavController = UINavigationController(rootViewController: trackerViewController)
        let statisticNavController = UINavigationController(rootViewController: statisticViewController)
        
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "tabBar_trackers"),
            selectedImage: nil
        )
        
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "tabBar_statistic"),
            selectedImage: nil)
        
        self.viewControllers = [trackerNavController,statisticNavController]
    }
    
    
}
