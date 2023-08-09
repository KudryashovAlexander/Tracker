//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Александр Кудряшов on 07.08.2023.
//

import UIKit

class TrackerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TrackerCollectionCell"
    
    var dayCount = 0 {
        didSet {
            dayCountLabel.text = dayCounterString(dayCount)
        }
    }
    
    //Значения емодзи, цвет трекера, цвет кнопки
    var tracker: Tracker? {
        didSet {
            if let tracker = tracker {
                emojieLabel.text = tracker.emojie
                trackerView.backgroundColor = tracker.color
                addTrackerDayButton.backgroundColor = tracker.color
                addTrackerDayButton.backgroundColor = tracker.color
            }
        }
    }
    
    //вью трекера
    private var trackerView: UIView {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.frame.size = CGSize(width: contentView.frame.size.width, height: 90)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return UIView()
    }
    
    //Круг под емоджи
    private var emojieBall: UIView {
        let view = UIView()
        view.frame.size = CGSize(width: contentView.frame.width, height: 90)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    //Емодзи
    private var emojieLabel: UILabel {
        let label = UILabel()
        label.frame.size = CGSize(width: 24, height: 24)
        label.font = .yPMedium16
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    //кнопка Закрепить
    var pinImageView: UIImageView {
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: 24, height: 24)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    //привычка или неругул событие
    private var trackerLabel: UILabel {
        let label = UILabel()
        label.font = .yPMedium12
        label.textColor = .ypWhite
        label.numberOfLines = 2
        label.textAlignment = .left
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    //Количество дней
    private var dayCountLabel: UILabel {
        let label = UILabel()
        label.font = .yPMedium12
        label.textAlignment = .left
        label.textColor = .ypBlack
        label.text = dayCounterString(dayCount)
        label.frame.size = CGSize(width: 101, height: 18)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }

    //кнопка нажатия кнопки
    private var addTrackerDayButton: UIButton {
        let button = UIButton()
        button.frame.size = CGSize(width: 34, height: 34)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 17
        button.imageView?.image = UIImage(named: "add_Tracker_button") ?? UIImage()
        button.addTarget(self, action: #selector(addDayCount), for: .touchUpInside)
        
        if let color = tracker?.color {
            color.withAlphaComponent(0.3)
            button.setTitleColor(color, for: .highlighted)
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(trackerView)
        trackerView.addSubview(emojieBall)
        emojieBall.addSubview(emojieLabel)
        trackerView.addSubview(pinImageView)
        trackerView.addSubview(trackerLabel)
        
        contentView.addSubview(dayCountLabel)
        contentView.addSubview(addTrackerDayButton)
        
        NSLayoutConstraint.activate([
            
            //view трекера
            trackerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            //Кнопка закрепить
            pinImageView.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            pinImageView.rightAnchor.constraint(equalTo: trackerView.rightAnchor, constant: 4),

            //Круг под емодзи
            emojieBall.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            emojieBall.leftAnchor.constraint(equalTo: trackerView.leftAnchor, constant: 12),
            
            //емодзи
            emojieLabel.centerXAnchor.constraint(equalTo: emojieBall.centerXAnchor),
            emojieLabel.centerYAnchor.constraint(equalTo: emojieBall.centerYAnchor),
            
            //привычка
            trackerLabel.bottomAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: 12),
            trackerLabel.rightAnchor.constraint(equalTo: trackerView.rightAnchor, constant: 12),
            trackerLabel.leftAnchor.constraint(equalTo: trackerView.leftAnchor, constant: 12),
            
            //Кол-во дней
            dayCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 24),
            dayCountLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            
            //кнопка добавления привычки
            addTrackerDayButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 12),
            addTrackerDayButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16)

        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    private func dayCounterString(_ number: Int) -> String {
        var text = String()
        switch number {
        case 1: text = "день"
        case 2,3,4: text = "дня"
        default: text = "дней"
        }
        return "\(number)" + " " + text
    }
    
    @objc
    private func addDayCount() {
        dayCount += 1
        addTrackerDayButton.imageView?.image = UIImage(named: "done_button") ?? UIImage()
    }
    
    
}
