//
//  FirstViewController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 06.08.2023.
//

import UIKit

class FirstViewController: UIViewController {
    private let logoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlue
        logoImageViewSupport()
        viewsConstrains()
    }
    
    private func logoImageViewSupport() {
        let image = UIImage(named: "Logo") ?? UIImage()
        logoImageView.image = image
        view.addSubview(logoImageView)
    }
    
    private func viewsConstrains() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func createNextView() {
        //TODO: - Метод следуюещего вью взависимости от сохранения информации
    }
    
}
