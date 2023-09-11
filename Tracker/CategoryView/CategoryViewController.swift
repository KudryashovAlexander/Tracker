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
        scrollView.isHidden = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.frame.size = contenSize
        view.backgroundColor = .ypWhite
        return view
    }()
    
    private var contenSize: CGSize{
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    private var categoryContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .ypBackground
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    private var categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.cellIdentifier)
        tableView.isScrollEnabled = false
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.tableHeaderView = UIView()
        return tableView
    }()
    
    private let createCategoryButton = UIButton().customBlackButton(title: "Добавить категорию")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        self.navigationItem.title = "Категория"

        layoutSupport()

    }
    
    private func layoutSupport() {
        
        emptyCategoryImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyCategoryImageView)
        
        emptyCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyCategoryLabel)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        categoryContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryContainer)
        
        categoryTableView.translatesAutoresizingMaskIntoConstraints = false
        categoryContainer.addSubview(categoryTableView)
        
        createCategoryButton.addTarget(self, action: #selector(createCategory), for: .touchUpInside)
        createCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(createCategoryButton)
        

        NSLayoutConstraint.activate([
            emptyCategoryImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyCategoryImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -62),
            
            emptyCategoryLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyCategoryLabel.topAnchor.constraint(equalTo: emptyCategoryImageView.bottomAnchor, constant: 8),
            
            categoryContainer.widthAnchor.constraint(equalToConstant: contentView.frame.width - 16 * 2),
            categoryContainer.heightAnchor.constraint(equalToConstant: 75 * 7),
            categoryContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            categoryContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            categoryTableView.topAnchor.constraint(equalTo: categoryContainer.topAnchor),
            categoryTableView.bottomAnchor.constraint(equalTo: categoryContainer.bottomAnchor),
            categoryTableView.leftAnchor.constraint(equalTo: categoryContainer.leftAnchor),
            categoryTableView.rightAnchor.constraint(equalTo: categoryContainer.rightAnchor),
            
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createCategoryButton.widthAnchor.constraint(equalToConstant: contentView.frame.width - 40),
            createCategoryButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
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
        return 7
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = categoryTableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.cellIdentifier, for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        //
        return UITableViewCell()
    }
    
}
