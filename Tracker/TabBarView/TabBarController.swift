//
//  TabBarController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 06.08.2023.
//

import UIKit
class TabBarController: UITabBarController {
    
    let trackerViewController = TrackersViewController()
    let statisticViewController = StatisticViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        
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
