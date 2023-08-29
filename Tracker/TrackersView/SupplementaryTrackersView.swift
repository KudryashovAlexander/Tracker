//
//  SupplementaryTrackersView.swift
//  Tracker
//
//  Created by Александр Кудряшов on 25.08.2023.
//

import UIKit

final class SupplementaryTrackersView: UICollectionReusableView {
    
    static let identifier = "SupplementaryTrackersView"
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init (frame:frame)
        
        titleLabel.font = .yPBold19
        titleLabel.textAlignment = .left
        titleLabel.textColor = .ypBlack
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        titleLabel.text = text
    }
}
