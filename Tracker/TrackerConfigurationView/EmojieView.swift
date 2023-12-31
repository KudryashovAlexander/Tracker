//
//  EmojieView.swift
//  Tracker
//
//  Created by Александр Кудряшов on 23.08.2023.
//

import UIKit

protocol EmojieViewDelegate: AnyObject {
    func selectedEmogie( _ emogie: String)
}

final class EmojieView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var emojieCollection = EmojieCollection()
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    weak var delegate: EmojieViewDelegate?
    var selectedEmogie: String?
        
    init(delegate: EmojieViewDelegate?) {
        self.delegate = delegate
        
        super .init(frame: CGRect())
        
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
        return emojieCollection.array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojieCell.cellIdentifier,for: indexPath) as? EmojieCell else {
            return UICollectionViewCell()
        }
        
        let text = emojieCollection.array[indexPath.row]
        
        if text == selectedEmogie {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            cell.backgroundColor = .ypLightGray
        }
        cell.configure(text: text)
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 16
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInset = UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
        return sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? EmojieCell {
            delegate?.selectedEmogie(cell.returnText())
            cell.backgroundColor = .ypLightGray
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EmojieCell
        cell?.backgroundColor = .ypWhite
    }
    
}

