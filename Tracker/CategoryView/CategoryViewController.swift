//
//  CategoryView.swift
//  Tracker
//
//  Created by Александр Кудряшов on 09.09.2023.
//

import UIKit

class CategoryViewController: UIViewController {
    
    private var emptyCategoryImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "noTracker")
        imageView.image = image
        imageView.contentMode = .scaleToFill
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //Добавить scrollView
        
    //Добавить тейблВьюКонтроллер
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        self.navigationItem.title = "Категория"

        view.addSubview(emptyCategoryImageView)
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
    
    
}
