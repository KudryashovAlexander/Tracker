//
//  TrackerAddViewController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 11.08.2023.
//

import Foundation
import UIKit

final class TrackerAddViewController: UIViewController {
    
    private var trackerButton = UIButton().customBlackButton(title: "Привычка")
    private var notRegularButton = UIButton().customBlackButton(title: "Нерегулярное событие")
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        self.navigationItem.title = "Создание трекера"
        
        trackerButton.addTarget(self,
                                action: #selector(pressAddTreker),
                                for: .touchUpInside)
        view.addSubview(trackerButton)
        trackerButton.translatesAutoresizingMaskIntoConstraints = false
        
        notRegularButton.addTarget(self,
                                action: #selector(pressAddNotRegularTrack),
                                for: .touchUpInside)
        view.addSubview(notRegularButton)
        notRegularButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            trackerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            trackerButton.heightAnchor.constraint(equalToConstant: 60),
            trackerButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            trackerButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            
            notRegularButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notRegularButton.topAnchor.constraint(equalTo: trackerButton.bottomAnchor, constant: 16),
            notRegularButton.heightAnchor.constraint(equalToConstant: 60),
            notRegularButton.leftAnchor.constraint(equalTo: trackerButton.leftAnchor),
            notRegularButton.rightAnchor.constraint(equalTo: trackerButton.rightAnchor)
        ])
    }
    
    @objc
    private func pressAddTreker(){
        showTrackerConfigurationView(trackerName: "Новая привычка", isRegular: true)
    }
    
    @objc
    private func pressAddNotRegularTrack() {
        showTrackerConfigurationView(trackerName: "Новое нерегелярное событие", isRegular: false)
    }
    
    private func showTrackerConfigurationView(trackerName: String, isRegular: Bool) {
        let trackerConfugurationView = TrackerConfigurationViewController()
        trackerConfugurationView.navName = trackerName
        trackerConfugurationView.isRegular = isRegular
        let naVC = UINavigationController(rootViewController: trackerConfugurationView)
        self.present(naVC, animated: true)
    }
}
