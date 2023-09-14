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
        view.backgroundColor = .ypWhite
        self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        
        
    

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
        
        tabBarBorder()
    }
    
    func tabBarBorder() {
        let lineView = UIView()
        lineView.backgroundColor = .ypGray
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        tabBar.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.leftAnchor.constraint(equalTo: tabBar.leftAnchor),
            lineView.rightAnchor.constraint(equalTo: tabBar.rightAnchor),
            lineView.topAnchor.constraint(equalTo: tabBar.topAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1.0)
        ])
    }
}
