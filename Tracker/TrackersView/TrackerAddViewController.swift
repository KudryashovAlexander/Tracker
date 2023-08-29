//
//  TrackerAddViewController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 11.08.2023.
//

import Foundation
import UIKit

final class TrackerAddViewController: UIViewController {
    
    private var trackerButton = UIButton()
    private var notRegularButton = UIButton()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        self.navigationItem.title = "Создание трекера"

        trackerButtonCongiguration()
        notRegularButtonCongiguration()

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
    
    private func trackerButtonCongiguration() {
        trackerButton = buttonSetup(button: trackerButton, buttonText: "Привычка")
        trackerButton.addTarget(self,
                                action: #selector(pressAddTreker),
                                for: .touchUpInside)
        view.addSubview(trackerButton)
    }
    
    private func notRegularButtonCongiguration() {
        notRegularButton = buttonSetup(button: notRegularButton, buttonText: "Нерегулярное событие")
        notRegularButton.addTarget(self,
                                action: #selector(pressAddNotRegularTrack),
                                for: .touchUpInside)
        view.addSubview(notRegularButton)
    }
    
    
    private func buttonSetup(button: UIButton, buttonText: String) -> UIButton {
        button.backgroundColor = .ypBlack
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle(buttonText, for: .normal)
        button.titleLabel?.font = .yPMedium16
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
