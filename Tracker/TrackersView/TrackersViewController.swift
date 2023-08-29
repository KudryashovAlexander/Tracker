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
    private let datePicker = UIDatePicker()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout())
    
    private let emptyCollectiionImage = UIImageView()
    private let emptyCollectionLabel = UILabel()
    
    private var searchText: String? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationSupport()
        filterCollectionView()

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
        datePicker.calendar.firstWeekday = 1
        
        datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        datePicker.locale = Locale(identifier: "ru_RU")
        
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
        currentDate = datePicker.date
        filterCollectionView()
        collectionView.reloadData()
    }
    
    private func filterCollectionView(){
        let calendar = Calendar.current
        let filterWeekDay = calendar.component(.weekday, from: currentDate)
        let filterText = (searchText ?? "").lowercased()
        
        visibleCategories = categories.compactMap({ category in
            let trackers = category.trackers.filter { tracker in
                let dateCondition = tracker.schedule.daysIsOn.contains { weekDay in
                    weekDay.numberValue == filterWeekDay && weekDay.isOn
                } == true
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
        
        var countDay = 0
        var isDone = false
        
        for trackerRecord in completedTrackers {
            if trackerRecord.id == id {
                countDay += 1
                let stringDate = trackerRecord.date.dayMounthYearString
                if stringDate == currentDate.dayMounthYearString {
                    isDone = true
                }
            }
        }
        return (countDay,isDone)
    }
    
    @objc
    private func add() {
        let vc = TrackerAddViewController()
        let naVC = UINavigationController(rootViewController: vc)
        self.present(naVC, animated: true)
    }
    
}

//MARK: - Extension TrackerConfigurationViewControllerProtocol{
extension TrackersViewController: TrackerConfigurationViewControllerProtocol {
    func addEndTracker(newCategory: TrackerCategory) {
        categories.append(newCategory)
        collectionView.reloadData()
    }
}

//MARK: - Extension TrackersViewControllerProtocol
extension TrackersViewController: TrackersViewCellProtocol {
    
    func addOrRemoveTrackerRecord(id: UUID, isAdd: Bool, indexPath idexPath: IndexPath) {
        if currentDate.isAfter(){
            return
        }
        
        let trackerRecord = TrackerRecord(id: id, date: currentDate)
        let trackerRecordDateString = trackerRecord.date.dayMounthYearString
        
        if isAdd {
            completedTrackers.append(trackerRecord)
        } else {
            completedTrackers.removeAll { trackerRec in
                trackerRecord.id == trackerRec.id &&
                trackerRecordDateString == trackerRec.date.dayMounthYearString
            }
        }
        collectionView.reloadItems(at: [idexPath])
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
        cell.indexPath = indexPath

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
