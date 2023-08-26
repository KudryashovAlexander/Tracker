//
//  EmojieCell.swift
//  Tracker
//
//  Created by Александр Кудряшов on 23.08.2023.
//

import UIKit

final class EmojieCell: UICollectionViewCell {
    
    static let cellIdentifier = "EmojieCell"
    
    var emojieLabel = UILabel()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        emojieLabel.font = .yPBold32
        emojieLabel.textAlignment = .center
        emojieLabel.frame.size = CGSize(width: 38, height: 38)
        emojieLabel.center = contentView.center
        contentView.addSubview(emojieLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
