//
//  NewTrackerTableViewCell.swift
//  Tracker
//
//  Created by Александр Кудряшов on 21.08.2023.
//

import UIKit

class NewTrackerTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "NewTrackerTableViewCell"
    
    var labelName = UILabel()
    var propertyImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        labelNameConfiguration()
        propertyImageViewConfiguration()
        LayoutConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func labelNameConfiguration() {
        labelName.font = .yPRegular17
        labelName.textColor = .ypBlack
        labelName.textAlignment = .left
        contentView.addSubview(labelName)
        
    }
    
    private func propertyImageViewConfiguration() {
        let image = UIImage(named: "property_nextView")
        propertyImageView.image = image
        contentView.addSubview(propertyImageView)
    }
    
    private func LayoutConfiguration() {
        
        labelName.translatesAutoresizingMaskIntoConstraints = false
        propertyImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelName.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            propertyImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            propertyImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        ])
        
    }
    
}
