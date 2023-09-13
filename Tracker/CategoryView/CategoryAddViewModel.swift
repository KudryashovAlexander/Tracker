//
//  CategoryAddViewModel.swift
//  Tracker
//
//  Created by Александр Кудряшов on 11.09.2023.
//

import Foundation

protocol CategoryAddViewModelDelegate {
    func changeCategory()
}

final class CategoryAddViewModel {
    
    var delegate: CategoryAddViewModelDelegate?
    var numberSimbol: ((Int) -> Void)?
    var oldNCategoryName: String?
    var categoryName: String? {
        didSet{
            if let categoryName = categoryName {
                numberSimbol?(categoryName.count)
            } else {
                numberSimbol?(0)
            }
        }
    }
    
    init(oldNCategoryName: String? = nil) {
        self.oldNCategoryName = oldNCategoryName
    }
    
    private let trackerCategoryStore = TrackerCategoryStory()
    
    func saveCategory() {
        guard let categoryName = categoryName else { return }
        let trackerCategory = TrackerCategory(name: categoryName, trackers: [])
        try! trackerCategoryStore.addCategory(trackerCategory)
        delegate?.changeCategory()
    }
    
    func renameCategory(newName: String) {
        guard let oldName = oldNCategoryName else {return}
        if newName != oldName {
            try! trackerCategoryStore.changeNameCategory(oldName: oldName, newName: newName)
            delegate?.changeCategory()
        }
    }
}

