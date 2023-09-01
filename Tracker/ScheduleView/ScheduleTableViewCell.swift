//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Александр Кудряшов on 24.08.2023.
//

import UIKit

protocol ScheduleTableViewCellProtocol: AnyObject {
    func changeIsOn(_ numberDay: Int)
}

final class ScheduleTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "ScheduleTableViewCell"
    
    private let dayLabel = UILabel()
    private var numberDay = Int()
    private let daySwitch = UISwitch()
    weak var delegate:ScheduleTableViewCellProtocol?
    
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
    
    func configure(text: String, numberDay: Int, isOn: Bool) {
        dayLabel.text = text
        self.numberDay = numberDay
        daySwitch.isOn = isOn
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
