//
//  CategoryAddViewModel.swift
//  Tracker
//
//  Created by Александр Кудряшов on 11.09.2023.
//

import Foundation

protocol CategoryAddViewModelDelegate {
    func addNewCategory()
}

final class CategoryAddViewModel {
    
    var delegate: CategoryAddViewModelDelegate?
    var numberSimbol: ((Int) -> Void)?
    var categoryName: String? {
        didSet{
            if let categoryName = categoryName {
                numberSimbol?(categoryName.count)
            } else {
                numberSimbol?(0)
            }
        }
    }
    
    private let trackerCategoryStore = TrackerCategoryStory()
    
    func saveCategory() {
        guard let categoryName = categoryName else { return }
        let trackerCategory = TrackerCategory(name: categoryName, trackers: [])
        try! trackerCategoryStore.addCategory(trackerCategory)
        delegate?.addNewCategory()
    }
}

