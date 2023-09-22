//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Александр Кудряшов on 07.08.2023.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TrackerCollectionCell"
    var viewModel: TrackerViewModel! {
        didSet {
            self.trackerLabel.text = viewModel.name
            self.emojieLabel.text = viewModel.emojie
            self.trackerView.backgroundColor = viewModel.color
            self.dayCount = viewModel.countDay
            self.dayIsDone = viewModel.pressButton
            self.pinImageView.isHidden = !viewModel.pinTracker
            bind()
        }
    }
    
    var dayCount = 0 {
        didSet {
            dayCountLabel.text = dayCounterString(dayCount)
        }
    }
        
    var dayIsDone = false {
        didSet {
            if dayIsDone == true {
                let image = UIImage(named: "done_button") ?? UIImage()
                addTrackerDayButton.setImage(image, for: .normal)
                addTrackerDayButton.backgroundColor = .ypWhite
                addTrackerDayButton.tintColor = trackerView.backgroundColor
                
            } else {
                let image = UIImage(named: "add_Tracker_button") ?? UIImage()
                addTrackerDayButton.setImage(image, for: .normal)
                addTrackerDayButton.backgroundColor = .ypWhite
                addTrackerDayButton.tintColor = trackerView.backgroundColor
                
            }
        }
    }
    
    private var trackerView = UIView()
    private var emojieBall = UIView()
    private var emojieLabel = UILabel()
    private var pinImageView = UIImageView()
    private var trackerLabel = UILabel()
    private var dayCountLabel = UILabel()
    private var addTrackerDayButton = UIButton()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        cellCreate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        
        guard let viewModel = viewModel else {return}
        viewModel.$name.bind { [weak self] name in
            self?.trackerLabel.text = name
        }
        viewModel.$emojie.bind { [weak self] emojie in
            self?.emojieLabel.text = emojie
        }
        viewModel.$color.bind { [weak self] color in
            self?.trackerView.backgroundColor = color
        }
        viewModel.$countDay.bind { [weak self] count in
            self?.dayCount = count
        }
        viewModel.$pressButton.bind { [weak self] isPressed in
            self?.dayIsDone = isPressed
        }
        viewModel.$pinTracker.bind { [weak self] isPin in
            self?.pinImageView.isHidden = !isPin
        }
        
    }
    
    private func cellCreate() {
        
        trackerViewSupport()
        emojieBallSupport()
        emojieLabelSupport()
        pinImageViewSuppoty()
        trackerLabelSupport()
        dayCountLabelSupport()
        addTrackerDayButtonSupport()
        
        contentView.addSubview(trackerView)
        trackerView.addSubview(emojieBall)
        trackerView.addSubview(pinImageView)
        emojieBall.addSubview(emojieLabel)
        trackerView.addSubview(pinImageView)
        trackerView.addSubview(trackerLabel)
        
        contentView.addSubview(dayCountLabel)
        contentView.addSubview(addTrackerDayButton)
        
        layoutSupport()
    }
    
    //MARK: - Methods
    private func trackerViewSupport(){
        trackerView.layer.masksToBounds = true
        trackerView.layer.cornerRadius = 16
        
        trackerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func emojieBallSupport(){
        emojieBall.layer.masksToBounds = true
        emojieBall.layer.cornerRadius = 12
        emojieBall.backgroundColor = UIColor.ypBall
        emojieBall.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func emojieLabelSupport(){
        emojieLabel.frame.size = CGSize(width: 24, height: 24)
        emojieLabel.font = .yPMedium16
        emojieLabel.textColor = .ypBlack
        emojieLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func pinImageViewSuppoty(){
        pinImageView.isHidden = true
        pinImageView.image = UIImage(named: "pinTracker") ?? UIImage()
        pinImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func trackerLabelSupport(){
        trackerLabel.font = .yPMedium12
        trackerLabel.textColor = .ypWhite
        trackerLabel.numberOfLines = 2
        trackerLabel.textAlignment = .left
        
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func dayCountLabelSupport(){
        dayCountLabel.font = .yPMedium12
        dayCountLabel.textAlignment = .left
        dayCountLabel.textColor = .ypBlack

        dayCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }

    private func addTrackerDayButtonSupport(){
        addTrackerDayButton.layer.masksToBounds = true
        addTrackerDayButton.layer.cornerRadius = 17
        addTrackerDayButton.addTarget(self, action: #selector(addDayCount), for: .touchUpInside)
        
        addTrackerDayButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layoutSupport(){
        NSLayoutConstraint.activate([
            
            trackerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            trackerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            trackerView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 90),
            
            pinImageView.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            pinImageView.rightAnchor.constraint(equalTo: trackerView.rightAnchor, constant: -4),
            pinImageView.heightAnchor.constraint(equalToConstant: 24),
            pinImageView.widthAnchor.constraint(equalToConstant: 24),

            emojieBall.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            emojieBall.leftAnchor.constraint(equalTo: trackerView.leftAnchor, constant: 12),
            emojieBall.heightAnchor.constraint(equalToConstant: 24),
            emojieBall.widthAnchor.constraint(equalToConstant: 24),
            
            emojieLabel.centerXAnchor.constraint(equalTo: emojieBall.centerXAnchor),
            emojieLabel.centerYAnchor.constraint(equalTo: emojieBall.centerYAnchor),
            
            trackerLabel.bottomAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: -12),
            trackerLabel.rightAnchor.constraint(equalTo: trackerView.rightAnchor, constant: -12),
            trackerLabel.leftAnchor.constraint(equalTo: trackerView.leftAnchor, constant: 12),
            
            dayCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            dayCountLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            
            addTrackerDayButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            addTrackerDayButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            addTrackerDayButton.heightAnchor.constraint(equalToConstant: 34),
            addTrackerDayButton.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func dayCounterString(_ number: Int) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("numberOfdays", comment: "number of check day tracker"),
                                                number)
    }
    
    @objc
    private func addDayCount() {
        viewModel?.changeRecord()
    }

    
}
