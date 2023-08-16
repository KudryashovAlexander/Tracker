//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 06.08.2023.
//

import UIKit
class TrackersViewController: UIViewController {
    
    private let sController = UISearchController()
    var categories: [TrackerCategory] = []
    var visibleCategories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var currentDate = Date()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)

        navigationSupport()
        self.collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

    }
    
    //Настройка навигейшн
    private func navigationSupport() {
        guard let navControl = navigationController else { return }
        let navBar = navControl.navigationBar
        
        let leftButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(add))
        leftButton.tintColor = .ypBlack
        navBar.topItem?.leftBarButtonItem = leftButton
        
        let datePicker = UIDatePicker()
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        
        datePicker.locale = Locale(identifier: "ru_RU")
        
        let rightButton = UIBarButtonItem(customView: datePicker)
        navBar.topItem?.rightBarButtonItem = rightButton
        
        self.navigationItem.title = "Трекеры"
        navBar.prefersLargeTitles = true
        
        sController.hidesNavigationBarDuringPresentation = false
        
        sController.searchBar.searchTextField.placeholder = "Поиск"
        self.navigationItem.searchController = sController
        
    }
    
    @objc
    private func add() {
        //TODO: - Метод перехода на вью с доабвление новой привычки или неругулярного события
        let vc = TrackerAddViewController()
        let naVC = UINavigationController(rootViewController: vc)
        self.present(naVC, animated: true)
    }
    
}

//MARK: - Extension CollectionViewDataSourse
extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if visibleCategories.isEmpty { return 0 }
        return visibleCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if visibleCategories.isEmpty { return 0 }
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell
        else { return UICollectionViewCell() }
        
        //Тестовая
        let tracker = Tracker(name: "Погладить кошку", color: .ypBlue, emojie: "К")
        cell.tracker = tracker
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/2 - 41, height: 148)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
}
