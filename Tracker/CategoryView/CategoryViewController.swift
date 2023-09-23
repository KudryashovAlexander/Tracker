//
//  CategoryView.swift
//  Tracker
//
//  Created by Александр Кудряшов on 09.09.2023.
//

import UIKit

class CategoryViewController: UIViewController {
    
    private let viewModel: CategoriesViewModel
    private let alertPresenter = AlertPresenter()
    
    private var emptyCategoryImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "noTracker")
        imageView.image = image
        imageView.contentMode = .scaleToFill
        imageView.isHidden = true
        return imageView
    }()
    
    private var emptyCategoryLabel: UILabel = {
        let label = UILabel()
        label.font = .yPMedium12
        label.textColor = .ypBlack
        label.text = String().categoryEmptyLabel
        label.textAlignment = .center
        label.numberOfLines = 2
        label.isHidden = true
        return label
    }()
    
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
    private var countElement = 0
    private var selectedCategory: String?
    
    private var categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.cellIdentifier)
        tableView.isScrollEnabled = false
        tableView.allowsMultipleSelection = false
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.tableHeaderView = UIView()
        return tableView
    }()
    
    private let createCategoryButton = UIButton().customBlackButton(title: String().buttonAddCategory)
    private var heightTableViewConstaraint: NSLayoutConstraint?
    private var viewHight = CGFloat()
    
    init(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
        selectedCategory = viewModel.selectedCategoryName
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        self.navigationItem.title = String().categoryName
        modalPresentationStyle = .none
        viewHight = view.frame.maxY - 98
        
        viewModel.$categories.bind { [weak self] _ in
            guard let self = self else {return}

            self.countElement = self.viewModel.categories.count
            self.categoryIsEmpty(self.countElement)
            self.categoryTableView.reloadData()
            self.updateContentSize()
            self.setHeightTableView(CGFloat(self.countElement * 75))
        }

        layoutSupport()
        
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
    }
    
    private func layoutSupport() {

        countElement = viewModel.categories.count
        categoryIsEmpty(countElement)
        
        updateContentSize()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        emptyCategoryImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emptyCategoryImageView)
        emptyCategoryImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        emptyCategoryImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -62).isActive = true
        
        emptyCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emptyCategoryLabel)
        emptyCategoryLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        emptyCategoryLabel.topAnchor.constraint(equalTo: emptyCategoryImageView.bottomAnchor, constant: 8).isActive = true
        
        categoryTableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryTableView)
        categoryTableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24).isActive = true
        categoryTableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        categoryTableView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32).isActive = true
        heightTableViewConstaraint = categoryTableView.heightAnchor.constraint(equalToConstant: CGFloat(countElement * 75))
        heightTableViewConstaraint?.isActive = true
        
        createCategoryButton.addTarget(self, action: #selector(createCategory), for: .touchUpInside)
        createCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(createCategoryButton)
        
        NSLayoutConstraint.activate([
            createCategoryButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            createCategoryButton.widthAnchor.constraint(equalToConstant: contentView.frame.width - 40),
            createCategoryButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    private func setHeightTableView(_ height: CGFloat) {
        heightTableViewConstaraint?.constant = height
    }
    
    private func categoryIsEmpty(_ count:Int) {
        if count == 0 {
            emptyCategoryLabel.isHidden = false
            emptyCategoryImageView.isHidden = false
        } else {
            emptyCategoryLabel.isHidden = true
            emptyCategoryImageView.isHidden = true
        }
    }

    
    private func updateContentSize() {
        let heightElement: CGFloat = CGFloat(integerLiteral: 24 + countElement * 75 + 50 + 60 + 16)
        let maxView = heightElement > viewHight ? heightElement : viewHight
        contenSize = CGSize(width: view.frame.width, height: maxView)
        scrollView.contentSize = contenSize
        contentView.frame.size = contenSize
    }
    
    @objc
    private func createCategory() {
        let createCategoryVC = CategoryAddViewController()
        createCategoryVC.viewModel = CategoryAddViewModel()
        let nc = UINavigationController(rootViewController: createCategoryVC)
        self.present(nc, animated: true)
    }
    
    private func changeCategory(index: Int) {
        let createCategoryVC = CategoryAddViewController()
        let categoryName = viewModel.categories[index].categoryName
        
        createCategoryVC.viewModel = CategoryAddViewModel(oldNCategoryName: categoryName)
        
        let nc = UINavigationController(rootViewController: createCategoryVC)
        self.present(nc, animated: true)
    }
    
    private func deleteCategory(index: Int) {
        let alertModel = AlertModel(title: String().alertDeleteCategory,
                                    message: "",
                                    buttonTitle: String().buttonDelete)
        
        alertPresenter.showAlertSheet(model: alertModel,
                                      viewController: self) {
            
            self.viewModel.deleteCategory(index: index)
        }
    }

}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = categoryTableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.cellIdentifier, for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.viewModel = viewModel.categories[indexPath.row]
        cell.backgroundColor = .ypBackground
        
        //FIXME: - метод предварительного выбора не работает!
//        if self.selectedCategory == viewModel.categories[indexPath.row].categoryName {
//            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
//                cell.viewModel.selectedCategory(select: true)
//            }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = categoryTableView.cellForRow(at: indexPath) as? CategoryTableViewCell else { return }
        cell.viewModel.selectedCategory(select: true)
        if viewModel.selectedCategoryName == viewModel.categories[indexPath.row].categoryName {
            viewModel.selectedCategoryName = nil
        } else {
            viewModel.selectedCategoryName = viewModel.categories[indexPath.row].categoryName
        }
        
        viewModel.selectCategory()
        self.dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = categoryTableView.cellForRow(at: indexPath) as? CategoryTableViewCell else { return }
        cell.viewModel.selectedCategory(select: false)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPath.count > 0 else {
            return nil
        }
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let action1 = UIAction(title: String().cellEdit) { [weak self] _ in
                self?.changeCategory(index: indexPath.row)
            }
            
            let action2 = UIAction(title: String().cellDelete, attributes: .destructive) { [weak self] _ in
                self?.deleteCategory(index: indexPath.row)
            }
            return UIMenu(children: [action1, action2])
        }
        return configuration
    }
    
}
