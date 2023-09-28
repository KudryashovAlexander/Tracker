//
//  StaticticSubView.swift
//  Tracker
//
//  Created by Александр Кудряшов on 24.09.2023.
//

import UIKit


final class StaticticSubView: UIView {
    
    private let viewModel: StatisticSubViewModel
    
    private let statisticCount: UILabel = {
        let label = UILabel()
        label.font = .yPBold34
        label.textAlignment = .left
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statisticName: UILabel = {
        let label = UILabel()
        label.font = .yPMedium12
        label.textAlignment = .left
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(viewModel: StatisticSubViewModel) {
        self.viewModel = viewModel
        statisticCount.text = String(viewModel.statisticNumber)
        statisticName.text = viewModel.statisticName
        super .init(frame: CGRect())
        
        bind()
        viewSupport()
        layoutSupport()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutSupport() {
        self.addSubview(statisticCount)
        self.addSubview(statisticName)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 90),
            
            statisticCount.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            statisticCount.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            statisticCount.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            
            statisticName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            statisticName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            statisticName.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12)
        ])
    }
    
    private func viewSupport() {
        self.backgroundColor = .ypWhite
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16
    }
    
    private func bind() {
        viewModel.$statisticNumber.bind { [weak self] newNumber in
            self?.statisticCount.text = String(newNumber)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        let color1 = UIColor(red: 0.99, green: 0.30, blue: 0.29, alpha: 1)
        let color2 = UIColor(red: 0.27, green: 0.9, blue: 0.62, alpha: 1)
        let color3 = UIColor(red: 0.0, green: 0.48, blue: 0.98, alpha: 1)
        gradient.colors = [color1.cgColor, color2.cgColor, color3.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 16).cgPath
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        mask.lineWidth = 1
        gradient.mask = mask
        self.layer.addSublayer(gradient)
    }
    
}


