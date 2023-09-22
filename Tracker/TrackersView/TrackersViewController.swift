//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 06.08.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    private let viewModel: TrackersViewModel
    
    private let sController = UISearchController(searchResultsController: nil)
    private let datePicker = UIDatePicker()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout())
    
    private let calendarHelper = CalendarHelper()
    private let emptyCollectiionImage = UIImageView()
    private let emptyCollectionLabel = UILabel()
    private var searchText: String? = nil
    
    init(viewModel: TrackersViewModel) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
        collectionIsEmpty(viewModel.collectionEmptyOrNosearch)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.hidesBarsOnSwipe = false
        sController.hidesNavigationBarDuringPresentation = false

        navigationSupport()

        self.collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        self.collectionView.register(SupplementaryTrackersView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SupplementaryTrackersView.identifier)
        
        emptyCollectiionImageSupport()
        emptyCollectionLabelSupport()
        
        collectionView.alwaysBounceVertical = true
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
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
        
        collectionIsEmpty(viewModel.collectionEmptyOrNosearch)
        bind()
        
    }
    
    func bind() {
//        guard let viewModel = viewModel else { return }
        viewModel.$visibleViewModels.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        viewModel.$collectionEmptyOrNosearch.bind { [weak self] emptyCellection in
            self?.collectionIsEmpty(emptyCellection)
        }
    }
    
    private func emptyCollectiionImageSupport() {
        emptyCollectiionImage.image = UIImage(named: "noTracker") ?? UIImage()
        emptyCollectiionImage.isHidden = true
    }
    
    private func emptyCollectionLabelSupport() {
        emptyCollectionLabel.font = .yPMedium12
        emptyCollectionLabel.textColor = .ypBlack
        emptyCollectionLabel.text = String().mainEmptyLabel
        emptyCollectionLabel.textAlignment = .center
        emptyCollectionLabel.numberOfLines = 1
        emptyCollectionLabel.isHidden = true
    }
    
    private func collectionIsEmpty(_ isEmpty: Bool?){
        if isEmpty == nil {
            emptyCollectiionImage.isHidden = true
            emptyCollectionLabel.isHidden = true
            return
        }
        if isEmpty == true {
            emptyCollectiionImage.image = UIImage(named: "noSearch") ?? UIImage()
            emptyCollectionLabel.text = String().mainNoSearch
            emptyCollectiionImage.isHidden = false
            emptyCollectionLabel.isHidden = false
            return
        }
        if isEmpty == false {
            emptyCollectiionImage.image = UIImage(named: "noTracker") ?? UIImage()
            emptyCollectionLabel.text = String().mainEmptyLabel
            emptyCollectiionImage.isHidden = false
            emptyCollectionLabel.isHidden = false
            return
        }
    }
    
    private func navigationSupport() {
        guard let navControl = navigationController else { return }
        navControl.hidesBarsOnSwipe = false
        let navBar = navControl.navigationBar
        
        let imageAdd = UIImage(named: "plusTracker") ?? UIImage()
        
        let leftButton = UIBarButtonItem(image: imageAdd,
                                         style: .done,
                                         target: self,
                                         action: #selector(add))
        
        leftButton.tintColor = .ypBlack
        navBar.topItem?.leftBarButtonItem = leftButton
                
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.calendar = calendarHelper.calendarUse
        
        datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        
        let rightButton = UIBarButtonItem(customView: datePicker)
        navBar.topItem?.rightBarButtonItem = rightButton
        
        self.navigationItem.title = String().mainTracker
        navBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.searchController = sController
        
        sController.hidesNavigationBarDuringPresentation = false
        sController.searchBar.searchTextField.delegate = self

    }
    @objc
    private func changeDate() {
        viewModel.changeDate(datePicker.date)
    }
    
    @objc
    private func add() {
        let vc = TrackerAddViewController()
        let naVC = UINavigationController(rootViewController: vc)
        self.present(naVC, animated: true)
    }
    
}

//MARK: - Extension UITextFieldDelegate
extension TrackersViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
           let updatedText = text.replacingCharacters(in: textRange, with: string)
               if updatedText.isEmpty {
                   viewModel.searchText(text: nil)
               } else {
                   viewModel.searchText(text: updatedText)
               }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.searchText(text: nil)
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

//MARK: - Extension CollectionViewDataSourse
extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.visibleViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.visibleViewModels[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell
        else { return UICollectionViewCell() }
        let cellViewModel = viewModel.visibleViewModels[indexPath.section].trackers[indexPath.row]
        cell.viewModel = cellViewModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SupplementaryTrackersView.identifier, for: indexPath) as? SupplementaryTrackersView else {
            return UICollectionReusableView()
        }
        let text = viewModel.visibleViewModels[indexPath.section].name
        view.configure(text: text)
        return view
    }
    
    private func pinTracker(id: UUID) {
        viewModel.pinTracker(id: id)
    }
    
    private func changeTracker(id: UUID) {
        viewModel.changeTracker(id: id)
    }
    
    private func deleteTracker(id: UUID) {
        viewModel.deleteTracker(id: id)
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
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else { return nil }
        
        let indexPath = indexPaths[0]
        
        let viewModelID = viewModel.visibleViewModels[indexPath.section].trackers[indexPath.row].id
        let trackerIsPin = viewModel.visibleViewModels[indexPath.section].trackers[indexPath.row].pinTracker
        let pintextAlert = trackerIsPin ? String().cellUnpin : String().cellPin
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let actionPin = UIAction(title: pintextAlert) { [weak self] _ in
                self?.pinTracker(id: viewModelID)
            }
            let actionChange = UIAction(title: String().cellEdit) { [weak self] _ in
                self?.changeTracker(id: viewModelID)
            }
            let actionDelete = UIAction(title: String().cellDelete, attributes: .destructive) { [weak self] _ in
                self?.deleteTracker(id: viewModelID)
            }
            return UIMenu(children: [actionPin, actionChange, actionDelete])
        }
        return configuration
    }
    
}
