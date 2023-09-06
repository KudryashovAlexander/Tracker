//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 06.08.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    private let sController = UISearchController()
    var categories: [TrackerCategory] = []
    var visibleCategories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var currentDate: Date {
        return calendarHelper.dateWithoutTime(datePicker.date)
    }
    
    private let datePicker = UIDatePicker()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout())
    
    private var calendarHelper = CalendarHelper()
    private let emptyCollectiionImage = UIImageView()
    private let emptyCollectionLabel = UILabel()
    private var trackerCategoryStore = TrackerCategoryStory()
    private var trackerRecordStore = TrackerRecordStore()
    
    private var searchText: String? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        categories = trackerCategoryStore.trackerCategory
        completedTrackers = trackerRecordStore.trackerRecords
        
        navigationSupport()
        filterCollectionView()
        
        trackerCategoryStore.delegate = self
        trackerRecordStore.delegate = self

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
        datePicker.calendar = calendarHelper.calendarUse
        
        datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        
        let rightButton = UIBarButtonItem(customView: datePicker)
        navBar.topItem?.rightBarButtonItem = rightButton
        
        self.navigationItem.title = "Трекеры"
        navBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.searchController = sController
        
        self.sController.hidesNavigationBarDuringPresentation = false
        sController.searchBar.searchTextField.placeholder = "Поиск"
        sController.searchBar.searchTextField.delegate = self

    }
    @objc
    private func changeDate() {
        filterCollectionView()
        collectionView.reloadData()
    }
    
    private func filterCollectionView(){
        let filterWeekDay = calendarHelper.calendarUse.component(.weekday, from: currentDate)
        let filterText = (searchText ?? "").lowercased()
        
        visibleCategories = categories.compactMap({ category in
            let trackers = category.trackers.filter { tracker in
                let dateCondition = tracker.schedule.daysOn.contains(filterWeekDay)
                let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                
                return dateCondition && textCondition
            }
            
            if trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(name: category.name, trackers: trackers)
        })
        
        collectionView.reloadData()
    }
    
    private func trackerFind(id: UUID) -> (Int,Bool) {
        return trackerRecordStore.countDayAndIsDone(id: id, date: currentDate)
    }
    
    @objc
    private func add() {
        let vc = TrackerAddViewController()
        let naVC = UINavigationController(rootViewController: vc)
        self.present(naVC, animated: true)
    }
    
}

//MARK: - Extension TrackersViewControllerProtocol
extension TrackersViewController: TrackersViewCellProtocol {
    
    func addOrRemoveTrackerRecord(id: UUID) {
        if currentDate.isAfter(){
            return
        }
        let trackerRecord = TrackerRecord(id: id, date: currentDate)
        try! trackerRecordStore.changeRecord(trackerRecord)
    }
}

//MARK: - Extension UITextFieldDelegate
extension TrackersViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        filterCollectionView()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = nil
        filterCollectionView()
        return true
    }
}
//MARK: - Extension TrackerConfigurationViewControllerDelegate
extension TrackersViewController: TrackerConfigurationViewControllerDelegate {
    func createTracker(_ newTracker: Tracker, category: TrackerCategory) {
        do {
            try trackerCategoryStore.addTracker(at: newTracker, category: category)
        } catch {
            print("Ошибка в добавлении нового трекера")
        }
    }
}

//MARK: - Extension TrackerCategoryStoryDelegate
extension TrackersViewController: TrackerCategoryStoryDelegate {
    func store(didUpdate trackerCategory: [TrackerCategory]) {
        categories = trackerCategory
        collectionView.reloadData()
    }
}

//MARK: - Extension TrackerRecordStoreDelegate
extension TrackersViewController: TrackerRecordStoreDelegate {
    func store(_ store: [TrackerRecord]) {
        completedTrackers = store
        collectionView.reloadData()
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
        cell.delegate = self
        cell.dayCount = trackerFind(id: tracker.id).0
        cell.dayIsDone = trackerFind(id: tracker.id).1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SupplementaryTrackersView.identifier, for: indexPath) as? SupplementaryTrackersView else {
            return UICollectionReusableView()
        }
        let text = visibleCategories[indexPath.section].name
        view.configure(text: text)
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
