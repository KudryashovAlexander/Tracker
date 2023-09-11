//
//  CategoryAddViewModel.swift
//  Tracker
//
//  Created by Александр Кудряшов on 11.09.2023.
//

import Foundation

final class CategoryAddViewModel {
    
    var numberSimbol: ((Int) -> Void)?
    var categoryName: String? {
        didSet{
            if let categoryName = categoryName {
                numberSimbol?(categoryName.count)
            }
        }
    }
    
    private let trackerCategoryStore = TrackerCategoryStory()
    
    func saveCategory() {
        guard let categoryName = categoryName else { return }
        let trackerCategory = TrackerCategory(name: categoryName, trackers: [])
        try! trackerCategoryStore.addCategory(trackerCategory)
    }
}
