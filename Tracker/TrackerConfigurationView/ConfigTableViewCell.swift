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
            bind()
            if let text = viewModel.selectedPoperty {
                self.selectedPropertyLabel.text = text
                self.isSelectedProperty = true
            }
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
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        layoutConfiguration(selectedIsActive: isSelectedProperty)
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
            guard let self = self,
                  let name = name else { return }
            self.selectedPropertyLabel.text = name
            self.layoutConfiguration(selectedIsActive:true)
        }
        
    }

    private func layoutConfiguration(selectedIsActive: Bool) {
        
        contentView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        propertyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(propertyNameLabel)
        propertyNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        propertyNameLabel.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: 26).isActive = selectedIsActive
        propertyNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = !selectedIsActive
        
        selectedPropertyLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(selectedPropertyLabel)
        selectedPropertyLabel.isHidden = !selectedIsActive
        selectedPropertyLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        selectedPropertyLabel.topAnchor.constraint(equalTo: propertyNameLabel.bottomAnchor, constant: 2).isActive = true

        propertyImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(propertyImageView)
        propertyImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        propertyImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
    }
    
}
