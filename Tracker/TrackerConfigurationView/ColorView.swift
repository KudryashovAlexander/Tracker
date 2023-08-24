//
//  ColorView.swift
//  Tracker
//
//  Created by Александр Кудряшов on 24.08.2023.
//

import UIKit

class ColorView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var colorCollection = ColorCollection()
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    
    var selectedColor = UIColor.ypCS1
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.cellIdentifier)
                
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = false
        
        self.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(colorCollection.array.count)
        return colorCollection.array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.cellIdentifier,for: indexPath) as? ColorCell else {
            return UICollectionViewCell()
        }
        cell.colorView.backgroundColor = colorCollection.array[indexPath.row]
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 8
        return cell
                
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ColorCell {
            if let color = cell.colorView.backgroundColor {
                selectedColor = color
                cell.layer.borderWidth = 3
                let borderColor = color.withAlphaComponent(0.3).cgColor
                cell.layer.borderColor = borderColor
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ColorCell
        cell?.layer.borderWidth = 0
    }
    
}


