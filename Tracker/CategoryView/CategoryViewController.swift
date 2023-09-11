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
    
    private var contenSize: CGSize{
        return CGSize(width: view.frame.width, height: 24 + 75*7 + 24 + 60)
    }
    
    private var categoryContainer = UIView()
    private var categoryTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        self.navigationItem.title = "Категория"

        view.addSubview(emptyCategoryImageView)
        emptyCategoryImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyCategoryLabel.translatesAutoresizingMaskIntoConstraints = false


        view.addSubview(emptyCategoryLabel)
        
        NSLayoutConstraint.activate([
            emptyCategoryImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyCategoryImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -62),
            
            emptyCategoryLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyCategoryLabel.topAnchor.constraint(equalTo: emptyCategoryImageView.bottomAnchor, constant: 8)
        ])
    }
    
    //Перенос в ViewModel
    private func isCategoryEmpty(_ isEmptyTableView: Bool) {
        if isEmptyTableView {
            emptyCategoryImageView.isHidden = false
            emptyCategoryLabel.isHidden = false
        } else {
            emptyCategoryImageView.isHidden = true
            emptyCategoryLabel.isHidden = true
        }
    }
    
    private func categoryContainerSupport() {
        categoryContainer.backgroundColor = .ypBackground
        categoryContainer.layer.masksToBounds = true
        categoryContainer.layer.cornerRadius = 16
    }
    
    private func categoryTableViewSupport() {
        categoryTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.cellIdentifier)
        categoryTableView.isScrollEnabled = false
        categoryTableView.separatorInset.left = 16
        categoryTableView.separatorInset.right = 16
        categoryTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        categoryTableView.tableHeaderView = UIView()
    }

}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cateories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = categoryTableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.cellIdentifier, for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        //
        return cell
    }
    
}
