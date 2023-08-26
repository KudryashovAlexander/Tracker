//
//  WelcomeViewContoller.swift
//  Tracker
//
//  Created by Александр Кудряшов on 05.08.2023.
//

import UIKit

final class WelcomeViewController: UIViewController {
    
    private var backGroundImage = UIImageView()
    private let button = UIButton()
    private let pageControl = UIPageControl()
    
    private let textArray = ["Отслеживайте только то, что хотите",
                             "Даже если это не литры воды и йога"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageSupport()
        buttonSupport()
        viewsConstrains()
    }
    
    
    private func buttonSupport() {
        button.titleLabel?.text = "Вот это технологии!"
        button.titleLabel?.font = .yPMedium16
        button.backgroundColor = .ypBlack
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc
    private func clickButton() {
        //TODO: - метод перехода на таббар
    }
    
    private func backgroundImageSupport() {
        backGroundImage.frame = view.frame
        backGroundImage.image = UIImage(named: "background1") ?? UIImage()
        view.addSubview(backGroundImage)
    }
    
    private func pageControlSupport() {
        pageControl.numberOfPages = textArray.count
        view.addSubview(pageControl)
    }

    
    
    private func viewsConstrains() {
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        
        NSLayoutConstraint.activate([
            button.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            button.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 50),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: 24)
        ])
    }
    
}
