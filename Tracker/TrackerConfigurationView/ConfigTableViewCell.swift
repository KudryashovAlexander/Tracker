//
//  NewTrackerTableViewCell.swift
//  Tracker
//
//  Created by Александр Кудряшов on 21.08.2023.
//

import UIKit

final class ConfigTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "NewTrackerTableViewCell"
    private var isSelectedProperty: Bool = false
    
    var viewModel: ConfigTableViewCellViewModel! {
        didSet {
            self.propertyNameLabel.text = viewModel.propertyName
            
            if let text = viewModel.selectedPoperty {
                self.selectedPropertyLabel.text = text
                self.isSelectedProperty = true
                setHeight(isActivate: isSelectedProperty)
            }
            bind()
        }
    }

    private var propertyNameLabel: UILabel = {
        let label = UILabel()
        label.font = .yPRegular17
        label.textColor = .ypBlack
        label.textAlignment = .left
        return label
    }()
    
    
    private var selectedPropertyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .yPRegular17
        label.textColor = .ypGray
        return label
    }()
    
    private var propertyImageView: UIImageView = {
        let image = UIImage(named: "property_nextView") ?? UIImage()
        return UIImageView(image: image)
    }()
    
    private var propertyNameLabelTopAnchor: NSLayoutConstraint?
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        propertyNameLabelTopAnchor = propertyNameLabel.centerYAnchor.constraint(equalTo: contentView.topAnchor)
        setHeight(isActivate: isSelectedProperty)
        layoutConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.$propertyName.bind { [ weak self] name in
            guard let self = self else { return }
            self.propertyNameLabel.text = self.viewModel.propertyName
        }
        
        viewModel.$selectedPoperty.bind { [weak self] name in
            guard let self = self else { return }
            guard let name = name else {
                self.setHeight(isActivate: false)
                return
            }
            self.selectedPropertyLabel.text = name
            self.setHeight(isActivate: true)
        }
        
    }
    
    private func setHeight(isActivate: Bool) {
        selectedPropertyLabel.isHidden = !isActivate

        if isActivate {
            propertyNameLabelTopAnchor?.constant = 26
        } else {
            propertyNameLabelTopAnchor?.constant = 75/2

        }
        
    }

    private func layoutConfiguration() {
        
        contentView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        propertyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(propertyNameLabel)
        propertyNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        propertyNameLabelTopAnchor?.isActive = true
        
        selectedPropertyLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(selectedPropertyLabel)
        selectedPropertyLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        selectedPropertyLabel.topAnchor.constraint(equalTo: propertyNameLabel.bottomAnchor, constant: 2).isActive = true

        propertyImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(propertyImageView)
        propertyImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        propertyImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
    }
    
}
