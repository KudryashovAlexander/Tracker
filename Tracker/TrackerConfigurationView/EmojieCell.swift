//
//  EmojieCell.swift
//  Tracker
//
//  Created by Александр Кудряшов on 23.08.2023.
//

import UIKit

class EmojieCell: UICollectionViewCell {
    
    static let cellIdentifier = "EmojieCell"
    
    var emojieLabel = UILabel()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        emojieLabel.font = .yPBold32
        emojieLabel.frame = CGRect(x: 0, y: 0, width: 32, height: 38)
        emojieLabel.center = contentView.center
        contentView.addSubview(emojieLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
