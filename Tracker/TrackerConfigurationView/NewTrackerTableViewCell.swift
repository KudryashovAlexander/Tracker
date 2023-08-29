//
//  NewTrackerTableViewCell.swift
//  Tracker
//
//  Created by Александр Кудряшов on 21.08.2023.
//

import UIKit

final class NewTrackerTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "NewTrackerTableViewCell"
    
    var propertyName = String() {
        didSet {
            propertyNameLabel.text = propertyName
            layoutConfiguration()
        }
    }
    var selectedProperty: String?

    private var propertyNameLabel = UILabel()
    private var selectedPropertyLabel = UILabel()
    private var propertyImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        propertyNameConfiguration()
        selectedPropertyConfiguration()
        propertyImageViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func propertyNameConfiguration() {
        propertyNameLabel.font = .yPRegular17
        propertyNameLabel.textColor = .ypBlack
        propertyNameLabel.textAlignment = .left
    }
    
    private func propertyImageViewConfiguration() {
        let image = UIImage(named: "property_nextView")
        propertyImageView.image = image
    }
    
    private func layoutConfiguration() {
        
        contentView.addSubview(propertyNameLabel)
        contentView.addSubview(propertyImageView)

        
        propertyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        propertyImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            contentView.heightAnchor.constraint(equalToConstant: 75),
            
            propertyNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            propertyImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            propertyImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
    
        ])
        
        if selectedProperty != nil {
            
            selectedPropertyLabel.text = selectedProperty
            contentView.addSubview(selectedPropertyLabel)
            
            selectedPropertyLabel.translatesAutoresizingMaskIntoConstraints = false
                        
            NSLayoutConstraint.activate([
                propertyNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
                selectedPropertyLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
                selectedPropertyLabel.topAnchor.constraint(equalTo: propertyNameLabel.bottomAnchor, constant: 2)
            ])
        } else {
            propertyNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        }
    }
    
    private func selectedPropertyConfiguration() {
        selectedPropertyLabel.textAlignment = .left
        selectedPropertyLabel.font = .yPRegular17
        selectedPropertyLabel.textColor = .ypGray
    }
    
}
