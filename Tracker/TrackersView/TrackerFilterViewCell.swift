//
//  TrackerFilterViewCell.swift
//  Tracker
//
//  Created by Александр Кудряшов on 25.09.2023.
//

import UIKit

final class TrackerFilterViewCell: UITableViewCell {
    
    static let cellIdentifier = "TrackerFilterTableViewCell"
    
    private var filterNameLabel: UILabel = {
        let label = UILabel()
        label.font = .yPRegular17
        label.textAlignment = .left
        label.textColor = .ypBlack
        return label
    }()
    
    private var chooseFilterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CategoryDone") ?? UIImage()
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
             
        filterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        chooseFilterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(filterNameLabel)
        contentView.addSubview(chooseFilterImageView)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 75),
            filterNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            filterNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            chooseFilterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chooseFilterImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name: String) {
        filterNameLabel.text = name
    }
    
    func configureIsSelected(_ isSelected: Bool) {
        chooseFilterImageView.isHidden = !isSelected
    }
    
}
