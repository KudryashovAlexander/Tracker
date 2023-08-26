//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 06.08.2023.
//

import UIKit
final class TrackersViewController: UIViewController {
    
    private let sController = UISearchController()
    var categories: [TrackerCategory] = mokVisibaleCategory
    var visibleCategories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var currentDate = Date()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout())
    
    private let emptyCollectiionImage = UIImageView()
    private let emptyCollectionLabel = UILabel()
    
    override func viewDidLoad() {
        sortedCollectionData()

        super.viewDidLoad()
        navigationSupport()

        
        self.collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        self.collectionView.register(SupplementaryTrackersView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SupplementaryTrackersView.identifier)
        
        emptyCollectiionImageSupport()
        emptyCollectionLabelSupport()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        emptyCollectiionImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyCollectiionImage)
        
        emptyCollectionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyCollectionLabel)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyCollectiionImage.heightAnchor.constraint(equalToConstant: 80),
            emptyCollectiionImage.widthAnchor.constraint(equalToConstant: 80),
            emptyCollectiionImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyCollectiionImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            emptyCollectionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyCollectionLabel.topAnchor.constraint(equalTo: emptyCollectiionImage.bottomAnchor, constant: 8),
            
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.allowsMultipleSelection = false

    }
    
    //если пустой коллекшн
    private func emptyCollectiionImageSupport() {
        emptyCollectiionImage.image = UIImage(named: "noTracker") ?? UIImage()
        emptyCollectiionImage.isHidden = true
    }
    
    private func emptyCollectionLabelSupport() {
        emptyCollectionLabel.font = .yPMedium12
        emptyCollectionLabel.textColor = .ypBlack
        emptyCollectionLabel.text = "Что будем отслеживать?"
        emptyCollectionLabel.textAlignment = .center
        emptyCollectionLabel.numberOfLines = 1
        emptyCollectionLabel.isHidden = true
    }
    
    private func collectionIsEmpty(_ isHidden: Bool){
        emptyCollectiionImage.isHidden = isHidden
        emptyCollectionLabel.isHidden = isHidden
    }
    private let datePicker = UIDatePicker()
    
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
                
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        datePicker.locale = Locale(identifier: "ru_RU")
        
        let rightButton = UIBarButtonItem(customView: datePicker)
        navBar.topItem?.rightBarButtonItem = rightButton
        
        self.navigationItem.title = "Трекеры"
        navBar.prefersLargeTitles = true
        navControl.hidesBarsOnSwipe = false
        
        sController.hidesNavigationBarDuringPresentation = false
        
        sController.searchBar.searchTextField.placeholder = "Поиск"
        sController.searchBar.searchTextField.delegate = self
        self.navigationItem.searchController = sController
        
    }
    @objc
    private func changeDate() {
        currentDate = datePicker.date
        sortedCollectionData()
        collectionView.reloadData()
        
    }
    
    private func sortedCollectionData() {
        var visCategory = [TrackerCategory]()
        for cat in categories {
            var trackers = [Tracker]()
            for tracker in cat.trackers {
                for daY in tracker.schedule.scheduleArray {
                    if daY.shortName == currentDate.weekdayNameString && daY.isOn {
                        trackers.append(tracker)
                        break
                    }
                }
            }
            if !trackers.isEmpty {
                visCategory.append(cat)
            }
        }
        visibleCategories = visCategory
    }
    
    private func searchTracker(textDidChange searchText: String) {
        var visCategory = [TrackerCategory]()
        for cat in categories {
            var trakers = [Tracker]()
            for _ in cat.trackers {
                trakers = cat.trackers.filter({$0.name.contains(searchText)})
                if !trakers.isEmpty{
                    visCategory.append(TrackerCategory(name: cat.name, trackers: trakers))
                }
            }
        }
        visibleCategories = visCategory
        collectionView.reloadData()
    }
    
    
    @objc
    private func add() {
        //TODO: - Метод перехода на вью с доабвление новой привычки или неругулярного события
        let vc = TrackerAddViewController()
        let naVC = UINavigationController(rootViewController: vc)
        self.present(naVC, animated: true)
    }
    
}
//MARK: - Extension UITextFieldDelegate
extension TrackersViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            searchTracker(textDidChange: text)
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        sortedCollectionData()
        return true
    }
    
    
}


//MARK: - Extension CollectionViewDataSourse
extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if visibleCategories.isEmpty {
            collectionIsEmpty(false)
            return 0
        }
        collectionIsEmpty(true)
        return visibleCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if visibleCategories.isEmpty {
            return 0
        }
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell
        else { return UICollectionViewCell() }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        cell.tracker = tracker
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SupplementaryTrackersView.identifier, for: indexPath) as? SupplementaryTrackersView else {
            return UICollectionReusableView()
        }
        view.titleLabel.text = visibleCategories[indexPath.section].name
        return view
        
    }
}

//MARK: - Extension UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 41)/2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority:.required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    
}
