//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Александр Кудряшов on 24.08.2023.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "ScheduleTableViewCell"
    
    let dayLabel = UILabel()
    var numberDay = Int()
    let daySwitch = UISwitch()
    var delegate:ScheduleViewControllerProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        dayLabelSupport()
        daySwitchSupport()
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dayLabel)
        
        daySwitch.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(daySwitch)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 75),
            
            dayLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            daySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            daySwitch.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func dayLabelSupport() {
        dayLabel.font = .yPRegular17
        dayLabel.textAlignment = .left
        dayLabel.textColor = .ypBlack
    }
    
    private func daySwitchSupport() {
        daySwitch.onTintColor = .ypBlue
        daySwitch.addTarget(self, action: #selector(changeDay), for: .valueChanged)
    }
    
    @objc
    private func changeDay() {
        delegate?.changeIsOn(numberDay)
    }
    
    
}
