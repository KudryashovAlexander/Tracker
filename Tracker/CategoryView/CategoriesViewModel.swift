//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Александр Кудряшов on 09.09.2023.
//

import Foundation

protocol CategoriesViewModelDelegate {
    func updateSelectedCategory(name: String?)
}

final class CategoriesViewModel {
    
    @Observable
    private(set) var cateories = [CategoryViewModel]()
    
    private var trackerCatStory = TrackerCategoryStory()
    var delegate:CategoriesViewModelDelegate
    var selectedCategoryName: String?
    
    init(delegate: CategoriesViewModelDelegate, selectedCategoryName: String? = nil) {
        self.delegate = delegate
        self.selectedCategoryName = selectedCategoryName
        self.cateories = getCategoryFromStore()
    }
    
    func deleteCategory(index: Int) {
        
        let categoryviewModel = cateories[index]
        try! trackerCatStory.deleteCategory(TrackerCategory(name: categoryviewModel.categoryName, trackers: []))
        self.cateories = getCategoryFromStore()
    }
        
    private func getCategoryFromStore() -> [CategoryViewModel] {
        var categoryArray = [CategoryViewModel]()
        for category in trackerCatStory.trackerCategoryViewModel {
            if category.categoryName == selectedCategoryName {
                category.selectedCategory(select: true)
            }
            categoryArray.append(category)
        }
        return categoryArray
    }
    
    func selectCategory() {
        delegate.updateSelectedCategory(name: selectedCategoryName)
    }
    
}

//MARK: - Extension CategoryAddViewModelDelegate
extension CategoriesViewModel: CategoryAddViewModelDelegate {
    func changeCategory() {
        self.cateories = getCategoryFromStore()
    }
}
