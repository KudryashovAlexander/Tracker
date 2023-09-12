//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Александр Кудряшов on 09.09.2023.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "CategoryTableViewCell"
    
    private var categoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = .yPRegular17
        label.textAlignment = .left
        label.textColor = .ypBlack
        return label
    }()
    
    private var chooseCategoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "categoryDone") ?? UIImage()
        return imageView
    }()
    
    var viewModel: CategoryViewModel! {
        didSet {
            self.categoryNameLabel.text = viewModel.categoryName
            self.chooseCategoryImageView.isHidden = !viewModel.categoryIsSelected
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
             
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        chooseCategoryImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(categoryNameLabel)
        contentView.addSubview(chooseCategoryImageView)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 75),
            categoryNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            chooseCategoryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chooseCategoryImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectedCategory(_ selected: Bool) {
        chooseCategoryImageView.isHidden = selected
    }
    
}
