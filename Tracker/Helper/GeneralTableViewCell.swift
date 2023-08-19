//
//  GeneralTableViewCell.swift
//  Tracker
//
//  Created by Александр Кудряшов on 19.08.2023.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {
    
    var viewCell = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(viewCell)
        viewCell.backgroundColor = contentView.backgroundColor
        
        viewCell.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            viewCell.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            viewCell.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
