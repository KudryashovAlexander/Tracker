//
//  CategoryAddViewModel.swift
//  Tracker
//
//  Created by Александр Кудряшов on 11.09.2023.
//

import Foundation

enum ErrorCategoryAddViewModel: Error {
    case invalidSaveCategory
    case invalidRenameCategory
}

final class CategoryAddViewModel {
    
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
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    init(oldNCategoryName: String? = nil) {
        self.oldNCategoryName = oldNCategoryName
    }
    
    func saveCategory() {
        guard let categoryName = categoryName else { return }
        let trackerCategory = TrackerCategory(name: categoryName, trackers: [])
        do {
            try trackerCategoryStore.addCategory(trackerCategory)
        } catch {
            print(ErrorCategoryAddViewModel.invalidSaveCategory)
        }
        
    }
    
    func renameCategory(newName: String) {
        guard let oldName = oldNCategoryName else {return}
        if newName != oldName {
            do {
                try trackerCategoryStore.changeNameCategory(oldName: oldName, newName: newName)
            } catch {
                 print(ErrorCategoryAddViewModel.invalidSaveCategory)
            }
           
        }
    }
}

