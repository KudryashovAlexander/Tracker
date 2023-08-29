//
//  ColorCell.swift
//  Tracker
//
//  Created by Александр Кудряшов on 24.08.2023.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    static let cellIdentifier = "ColorCell"
    
    private var colorView = UIView()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        colorView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = 6
        colorView.center = contentView.center
        contentView.addSubview(colorView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(color: UIColor) {
        colorView.backgroundColor = color
    }
    
    func selectedColor() -> UIColor {
        return colorView.backgroundColor ?? UIColor()
    }
    
}
