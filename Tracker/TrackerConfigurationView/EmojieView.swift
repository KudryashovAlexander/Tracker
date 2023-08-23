//
//  EmojieView.swift
//  Tracker
//
//  Created by Александр Кудряшов on 23.08.2023.
//

import UIKit

class EmojieView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var emojieCollection = EmojieCollection()
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    
    var selectedEmojie = String()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        selectedEmojie = emojieCollection.array.first!
        collectionView.register(EmojieCell.self, forCellWithReuseIdentifier: EmojieCell.cellIdentifier)
                
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
        print(emojieCollection.array.count)
        return emojieCollection.array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojieCell.cellIdentifier,for: indexPath) as? EmojieCell else {
            return UICollectionViewCell()
        }
        cell.emojieLabel.text = emojieCollection.array[indexPath.row]
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 6
        return cell
                
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width/6, height: self.frame.height/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? EmojieCell {
            selectedEmojie = cell.emojieLabel.text!
            cell.backgroundColor = .ypGray
            print("Выбрана эмоция \(String(describing: cell.emojieLabel.text))")
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EmojieCell
        cell?.backgroundColor = .ypWhite
    }
    
}
