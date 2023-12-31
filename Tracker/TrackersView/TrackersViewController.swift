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
    
    private let filterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlue
        button.setTitle(String().mainFilter, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .yPRegular17
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.isHidden = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
   
    private let emptyCollectiionImage = UIImageView()
    private let emptyCollectionLabel = UILabel()
    private let calendarHelper = CalendarHelper()
    private var searchText: String? = nil
    private let alertpresenter = AlertPresenter()
    private let analyticsService = AnalyticsService()
    
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
        view.backgroundColor = .ypWhite
        
        self.navigationController?.hidesBarsOnSwipe = false
        sController.hidesNavigationBarDuringPresentation = false
        navigationSupport()
        
        //EMPTY COLLECTION
        emptyCollectiionImageSupport()
        emptyCollectionLabelSupport()
        emptyCollectiionImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyCollectiionImage)
        
        emptyCollectionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyCollectionLabel)
        
        NSLayoutConstraint.activate([
            emptyCollectiionImage.heightAnchor.constraint(equalToConstant: 80),
            emptyCollectiionImage.widthAnchor.constraint(equalToConstant: 80),
            emptyCollectiionImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyCollectiionImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            emptyCollectionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyCollectionLabel.topAnchor.constraint(equalTo: emptyCollectiionImage.bottomAnchor, constant: 8),
            
        ])

        //COLLECTION LAYOUT
        self.collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        self.collectionView.register(SupplementaryTrackersView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SupplementaryTrackersView.identifier)
        collectionView.backgroundColor = .ypWhite
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        
        //FILTER BUTTON
        filterButton.addTarget(self, action: #selector(showFilter), for: .touchUpInside)
        view.addSubview(filterButton)
        NSLayoutConstraint.activate([
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        collectionIsEmpty(viewModel.collectionEmptyOrNosearch)
        analyticsService.report(event: "open_main", params: ["open_main" : 1])
        
        bind()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report(event: "close_main", params: ["close_main" : 1])
    }
    
    func bind() {
        viewModel.$visibleViewModels.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        viewModel.$collectionEmptyOrNosearch.bind { [weak self] emptyCollection in
            self?.collectionIsEmpty(emptyCollection)
        }
    }
    @objc
    private func showFilter() {
        let vc = TrackerFilterViewController()
        let navVC = UINavigationController(rootViewController: vc)
        vc.delegate = self.viewModel
        vc.selectedFilter = self.viewModel.selectedFilter
        self.present(navVC, animated: true)
        analyticsService.report(event: "click_main_filter", params: ["filter" : 1])
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
            collectionView.isHidden = false
            filterButton.isHidden = false
            return
        }
        if isEmpty == true {
            emptyCollectiionImage.image = UIImage(named: "noSearch") ?? UIImage()
            emptyCollectionLabel.text = String().mainNoSearch
            emptyCollectiionImage.isHidden = false
            emptyCollectionLabel.isHidden = false
            collectionView.isHidden = true
            filterButton.isHidden = true
            return
        }
        if isEmpty == false {
            emptyCollectiionImage.image = UIImage(named: "noTracker") ?? UIImage()
            emptyCollectionLabel.text = String().mainEmptyLabel
            emptyCollectiionImage.isHidden = false
            emptyCollectionLabel.isHidden = false
            collectionView.isHidden = true
            filterButton.isHidden = false
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
        analyticsService.report(event: "click_main_add_track", params: ["add_track" : 1])
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
        let trackerAndcategory = viewModel.changeTracker(id: id)
        guard let tracker = trackerAndcategory.0,
              let trackerCategory = trackerAndcategory.1 else { return }
        
        let viewModel = TrackerConfigurationViewModel(trackerType: .regular,
                                                      trackerConfigurationType: .change,
                                                      tracker: tracker,
                                                      trackerCategory: trackerCategory)
        let trackerConfugurationView = TrackerConfigurationViewController(viewModel: viewModel)
        let naVC = UINavigationController(rootViewController: trackerConfugurationView)
        self.present(naVC, animated: true)
    }
    
    private func deleteTracker(id: UUID) {
        let alertModel = AlertModel(title: "Уверены что хотите удалить трекер?",
                                    message: "",
                                    buttonTitle: "Удалить")
        alertpresenter.showAlertSheet(model: alertModel, viewController: self) {
            self.viewModel.deleteTracker(id: id)
        }
        analyticsService.report(event: "click_main_delete", params: ["delete" : 1])
        collectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let viewModelID = viewModel.visibleViewModels[indexPath.section].trackers[indexPath.row].id
        let trackerIsPin = viewModel.visibleViewModels[indexPath.section].trackers[indexPath.row].pinTracker
        let pintextAlert = trackerIsPin ? String().cellUnpin : String().cellPin
        let identifier = indexPath as NSCopying
        
        let configuration = UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { _ in
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
    
    func collectionView(_ collectionView: UICollectionView,previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        guard let indexPath = configuration.identifier as? IndexPath else {
            return nil
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell else {
            return nil
        }
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(roundedRect: cell.viewForContextMenu().bounds, cornerRadius: 16)
        
        let targetedPreview = UITargetedPreview(view: cell.viewForContextMenu(), parameters: parameters)
        
        return targetedPreview
    }
    
}
