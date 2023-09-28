//
//  TrackerConfigurationViewController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 16.08.2023.
//

import UIKit

final class TrackerConfigurationViewController: UIViewController {
        
    private let viewModel: TrackerConfigurationViewModel
        
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhite
        scrollView.frame = view.bounds
        scrollView.contentSize = contenSize
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.frame.size = contenSize
        view.backgroundColor = .ypWhite
        return view
    }()
    
    private var contenSize = CGSize()
    
    private var countDay: Int?
    private var countDayLabel = UILabel()
    
    private let nameTrackerConteiner = UIView()
    private var hightNameTrackerConteinerConstraint: NSLayoutConstraint?
    
    private let nameTrackerTextField = UITextField().customTextField(placeHolder: String().trackerEditPlaceHolder)
    
    private var attentionLabel = UILabel().attenteionLabel()
    
    private let propertyTableViewConteiner = UIView()
    private let propertyTableView = UITableView()
    
    private lazy var emojieCollectionView = EmojieView(delegate: self)
    private let emojieNameLabel = UILabel()
    
    private lazy var colorCollectionView = ColorView(delegate: self)
    private let colorNameLabel = UILabel()
    
    private let canselButton = UIButton().customRedButton(title: String().buttonCansel)
    private let createButton = UIButton().customBlackButton(title: "")
    
        
    init(viewModel: TrackerConfigurationViewModel) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        propertyTableView.delegate = self
        propertyTableView.dataSource = self
        nameTrackerTextField.delegate = self
        
        countDayLabelSupport()
        
        nameTrackerConteinerSupport()
        nameTrackerTextFieldSupport()
        
        propertyTableViewConteinerSupport()
        propertyTableViewSupport()
        
        emojieNameLabelSupport()
        colorNameLabelSupport()
        
        hightNameTrackerConteinerConstraint = nameTrackerConteiner.heightAnchor.constraint(equalToConstant: 75)
        setHeightTextFieldContainer(viewModel.attentionIsHidden)
        
        layoutSupport()
        updateContentSize()
    }
    
    private func layoutSupport() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        nameTrackerConteiner.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameTrackerConteiner)
        
        if countDay != nil {
            contentView.addSubview(countDayLabel)
            countDayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24).isActive = true
            countDayLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
            countDayLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
            countDayLabel.heightAnchor.constraint(equalToConstant: 38).isActive = true
            nameTrackerConteiner.topAnchor.constraint(equalTo: countDayLabel.bottomAnchor, constant: 40).isActive = true
        } else {
            nameTrackerConteiner.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24).isActive = true
        }
        
        nameTrackerConteiner.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32).isActive = true
        hightNameTrackerConteinerConstraint?.isActive = true
        nameTrackerConteiner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        nameTrackerTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTrackerConteiner.addSubview(nameTrackerTextField)
        
        attentionLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTrackerConteiner.addSubview(attentionLabel)
        
        propertyTableViewConteiner.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(propertyTableViewConteiner)
        
        propertyTableView.translatesAutoresizingMaskIntoConstraints = false
        propertyTableViewConteiner.addSubview(propertyTableView)
        
        emojieCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojieCollectionView)
        
        emojieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojieNameLabel)
        
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorCollectionView)
        
        colorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorNameLabel)
        
        canselButton.addTarget(self, action: #selector(canselPress), for: .touchUpInside)
        canselButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(canselButton)
        
        createButton.addTarget(self, action: #selector(createPress), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        changeCreateButton(viewModel.buttonIsEnabled)
        contentView.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            
            nameTrackerTextField.topAnchor.constraint(equalTo: nameTrackerConteiner.topAnchor),
            nameTrackerTextField.leftAnchor.constraint(equalTo: nameTrackerConteiner.leftAnchor),
            nameTrackerTextField.rightAnchor.constraint(equalTo: nameTrackerConteiner.rightAnchor),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            
            propertyTableViewConteiner.topAnchor.constraint(equalTo: nameTrackerConteiner.bottomAnchor, constant: 24),
            propertyTableViewConteiner.widthAnchor.constraint(equalTo: nameTrackerConteiner.widthAnchor),
            propertyTableViewConteiner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            propertyTableViewConteiner.heightAnchor.constraint(equalToConstant: CGFloat(75 * viewModel.tableViewCellViewModel.count)),
            
            propertyTableView.topAnchor.constraint(equalTo: propertyTableViewConteiner.topAnchor),
            propertyTableView.bottomAnchor.constraint(equalTo: propertyTableViewConteiner.bottomAnchor),
            propertyTableView.leftAnchor.constraint(equalTo: propertyTableViewConteiner.leftAnchor),
            propertyTableView.rightAnchor.constraint(equalTo: propertyTableViewConteiner.rightAnchor),
            
            emojieCollectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojieCollectionView.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            emojieCollectionView.topAnchor.constraint(equalTo: propertyTableViewConteiner.bottomAnchor, constant: 50),
            emojieCollectionView.heightAnchor.constraint(equalToConstant: 52 * 3 + 48),
            
            emojieNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 28),
            emojieNameLabel.bottomAnchor.constraint(equalTo: emojieCollectionView.topAnchor),
            
            colorCollectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorCollectionView.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            colorCollectionView.topAnchor.constraint(equalTo: emojieCollectionView.bottomAnchor, constant: 34),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 52 * 3 + 48),
            
            colorNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 28),
            colorNameLabel.bottomAnchor.constraint(equalTo: colorCollectionView.topAnchor),
            
            canselButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            canselButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            canselButton.widthAnchor.constraint(equalToConstant: contentView.frame.width / 2 - 20 - 4),
            canselButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            createButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            createButton.widthAnchor.constraint(equalToConstant: contentView.frame.width / 2 - 20 - 4),
            createButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        view.layoutIfNeeded()
        
    }
    
    private func bind() {
        self.navigationItem.title = viewModel.viewName
        nameTrackerTextField.text = viewModel.trackerName
        
        viewModel.$attentionIsHidden.bind { [weak self] isHidden in
            guard let self = self else { return }
            self.setHeightTextFieldContainer(isHidden)
        }
        
        viewModel.$buttonIsEnabled.bind { [weak self] isEnabled in
            guard let self = self else { return }
            self.changeCreateButton(isEnabled)
        }
        
        self.countDay = viewModel.daysRecord
        if let name = viewModel.buttonName {
            self.createButton.setTitle(name, for: .normal)
        }
        
        emojieCollectionView.selectedEmogie = viewModel.trackerEmodji
        colorCollectionView.selectedColor = viewModel.trackerColor
        
    }
    
    private func setHeightTextFieldContainer(_ isHidden: Bool) {
        attentionLabel.isHidden = isHidden
        attentionLabel.centerXAnchor.constraint(equalTo: nameTrackerConteiner.centerXAnchor).isActive = !isHidden
        attentionLabel.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 8).isActive = !isHidden
        
        if isHidden {
            hightNameTrackerConteinerConstraint?.constant = 75
            updateContentSize()
        } else {
            hightNameTrackerConteinerConstraint?.constant = 113
            updateContentSize()
        }
    }
    
    private func changeCreateButton(_ isEnabled: Bool){
        createButton.isEnabled = isEnabled
        if isEnabled {
            createButton.backgroundColor = .ypBlack
        } else {
            createButton.backgroundColor = .ypGray
        }
    }
    
    private func updateContentSize() {
        var heightElement = 24 + Int(nameTrackerConteiner.frame.size.height) + 25 + viewModel.tableViewCellViewModel.count * 75 + 60 + Int(emojieCollectionView.frame.size.height) + 34 + Int(colorCollectionView.frame.size.height) + 16 + 60 + 34
        if countDay != nil {
            heightElement += 78
        }
        contenSize = CGSize(width: view.frame.width, height: CGFloat(heightElement))
        scrollView.contentSize = contenSize
        contentView.frame.size = contenSize
    }
    
    private func countDayLabelSupport() {
        guard let countDay = countDay else { return }
        let countDayText = String.localizedStringWithFormat(NSLocalizedString("numberOfdays", comment: "number of check day tracker"), countDay)
        countDayLabel.text = countDayText
        countDayLabel.font = .yPBold32
        countDayLabel.textAlignment = .center
        countDayLabel.textColor = .ypBlack
        countDayLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func nameTrackerConteinerSupport() {
        nameTrackerConteiner.backgroundColor = .ypWhite
    }
    
    private func nameTrackerTextFieldSupport() {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: nameTrackerTextField.frame.height))
    
        let button = UIButton(type: .custom)
        button.frame.size = CGSize(width: 41, height: 41)
        button.center.y = rightView.center.y
        let image = UIImage(named: "textfieldCansel_button")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(removeText), for: .touchUpInside)
        rightView.addSubview(button)
        
        nameTrackerTextField.rightView = rightView
        nameTrackerTextField.rightViewMode = .whileEditing
    }
    
    @objc
    private func removeText() {
        nameTrackerTextField.text = ""
    }
    
    
    private func propertyTableViewConteinerSupport() {
        propertyTableViewConteiner.backgroundColor = .ypBackground
        propertyTableViewConteiner.layer.masksToBounds = true
        propertyTableViewConteiner.layer.cornerRadius = 16

        propertyTableView.tableHeaderView = UIView()
    }
    
    private func propertyTableViewSupport() {
        propertyTableView.register(ConfigTableViewCell.self, forCellReuseIdentifier: ConfigTableViewCell.cellIdentifier)
        propertyTableView.isScrollEnabled = false
        propertyTableView.separatorInset.left = 16
        propertyTableView.separatorInset.right = 16
        propertyTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
    }
    
    
    private func emojieNameLabelSupport() {
        emojieNameLabel.text = EmojieCollection().name
        emojieNameLabel.font = .yPBold19
        emojieNameLabel.textAlignment = .left
    }
    
    private func colorNameLabelSupport() {
        colorNameLabel.text = ColorCollection().name
        colorNameLabel.font = .yPBold19
        colorNameLabel.textAlignment = .left
    }
    
    @objc
    private func canselPress() {
        self.dismiss(animated: true)
    }
    
    
    @objc
    private func createPress(){
        viewModel.pressButton()
    }

}
//MARK: - Extension UITexFieldDelegate
extension TrackerConfigurationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if updatedText.isEmpty {
                viewModel.trackerName = nil
            } else {
                viewModel.trackerName = updatedText
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//MARK: - Extension UITableViewDataSource, UITableViewDelegate
extension TrackerConfigurationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableViewCellViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConfigTableViewCell.cellIdentifier, for: indexPath)
        guard let newTrackerCell = cell as? ConfigTableViewCell else {
             return UITableViewCell()
        }
        
        newTrackerCell.viewModel = viewModel.tableViewCellViewModel[indexPath.row]
        newTrackerCell.selectionStyle = .none
        newTrackerCell.backgroundColor = .ypBackground
        return newTrackerCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            createCategoryViewController()
        }
        
        if indexPath.row == 1 {
            createScheduleViewController()
        }
        
    }
    
    private func createScheduleViewController() {
        let vc = ScheduleViewController()
        vc.schedule = self.viewModel.trackerSchedule
        vc.delegate = self.viewModel
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    private func createCategoryViewController() {
        let categoriesViewModel = CategoriesViewModel(delegate: self.viewModel, selectedCategoryName: viewModel.categoryName)
        let vc = CategoryViewController(viewModel: categoriesViewModel)
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
}

//MARK: - Exetension EmojieViewDelegate
extension TrackerConfigurationViewController: EmojieViewDelegate {
    func selectedEmogie( _ emogie: String) {
        viewModel.trackerEmodji = emogie
    }
}

//MARK: - Exetension ColorViewDelegate
extension TrackerConfigurationViewController: ColorViewDelegate {
    func changeColor(_ color: UIColor) {
        viewModel.trackerColor = color
    }
}
