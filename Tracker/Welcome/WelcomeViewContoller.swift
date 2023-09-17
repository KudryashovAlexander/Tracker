//
//  WelcomeViewContoller.swift
//  Tracker
//
//  Created by Александр Кудряшов on 05.08.2023.
//

import UIKit

final class WelcomeViewController: UIViewController {
    
    private var welcomeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .yPBold32
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    init(labelText: String, imageName: String) {
        super.init(nibName: nil, bundle: nil)
        
        welcomeLabel.text = labelText
        let image = UIImage(named: imageName) ?? UIImage()
        welcomeImageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeImageView.frame = view.frame
        welcomeImageView.center = view.center
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeImageView)
        welcomeImageView.addSubview(welcomeLabel)
        
        NSLayoutConstraint.activate([
            welcomeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
}
