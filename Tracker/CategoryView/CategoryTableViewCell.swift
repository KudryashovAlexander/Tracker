//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Александр Кудряшов on 09.09.2023.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
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
        imageView.isHidden = true
        return imageView
    }()
    
    var viewModel:CategoryViewModel! {
        didSet {
            self.categoryNameLabel.text = self.viewModel.categoryName
            categoryIsSelect(viewModel.categoryIsSelected)
            bind()
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
    
    private func bind() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.$categoryName.bind { [weak self] name in
            guard let self = self else { return }
            self.categoryNameLabel.text = self.viewModel.categoryName
        }
        
        viewModel.$categoryIsSelected.bind { [weak self] isSelected in
            guard let self = self else {return}
            self.categoryIsSelect(isSelected)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func categoryIsSelect(_ selected: Bool) {
        chooseCategoryImageView.isHidden = !selected
    }
    
}
