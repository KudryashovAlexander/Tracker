//
//  CategoryView.swift
//  Tracker
//
//  Created by Александр Кудряшов on 09.09.2023.
//

import UIKit

class CategoryViewController: UIViewController {
    
    private var viewModel: CategoriesViewModel!
    
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
        label.text = """
                        Привычки и события можно
                        объединить по смыслу
                    """
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
    
    private var contenSize: CGSize {
        return CGSize(width: view.frame.width, height: 800)
    }
    
    private var categoryTableView = UITableView()
    
    private let createCategoryButton = UIButton().customBlackButton(title: "Добавить категорию")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        self.navigationItem.title = "Категория"
        
        viewModel = CategoriesViewModel()
        viewModel.$cateories.bind { [weak self] _ in
            guard let self = self else {return}
            self.categoryTableView.reloadData()
        }
        
        tableViewSupport()
        
        layoutSupport()
        
        categoryTableView.dataSource = self
        categoryTableView.delegate = self

    }
    
    private func layoutSupport() {
        
        emptyCategoryImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyCategoryImageView)
        
        emptyCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyCategoryLabel)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        categoryTableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryTableView)
        
        createCategoryButton.addTarget(self, action: #selector(createCategory), for: .touchUpInside)
        createCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(createCategoryButton)
        

        NSLayoutConstraint.activate([
            emptyCategoryImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyCategoryImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -62),
            
            emptyCategoryLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyCategoryLabel.topAnchor.constraint(equalTo: emptyCategoryImageView.bottomAnchor, constant: 8),
            
            categoryTableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            categoryTableView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            categoryTableView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createCategoryButton.widthAnchor.constraint(equalToConstant: contentView.frame.width - 40),
            createCategoryButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func tableViewSupport() {
        categoryTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.cellIdentifier)
        categoryTableView.isScrollEnabled = false
        categoryTableView.separatorInset.left = 16
        categoryTableView.separatorInset.right = 16
        categoryTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        categoryTableView.tableHeaderView = UIView()
    }
    
    @objc
    func createCategory() {
        let createCategoryVC = CategoryAddViewController()
        let nc = UINavigationController(rootViewController: createCategoryVC)
        self.present(nc, animated: true)
    }
    
    //ПЕРЕНЕСТИ ВО ВЬЮМОДЕЛЬ
    private func isCategoryEmpty(_ isEmptyTableView: Bool) {
        if isEmptyTableView {
            emptyCategoryImageView.isHidden = false
            emptyCategoryLabel.isHidden = false
        } else {
            emptyCategoryImageView.isHidden = true
            emptyCategoryLabel.isHidden = true
        }
    }

}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.cateories.count)
        return viewModel.cateories.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = categoryTableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.cellIdentifier, for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.viewModel = viewModel.cateories[indexPath.row]
        print(cell.viewModel.categoryName)
        return UITableViewCell()
    }
    
}
