//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Александр Кудряшов on 09.09.2023.
//

import Foundation

protocol CategoriesViewModelDelegate: AnyObject {
    func updateSelectedCategory(name: String?)
}

final class CategoriesViewModel {
    
    @Observable
    private(set) var categories = [CategoryViewModel]()
    
    private let trackerCatStory = TrackerCategoryStore.shared
    weak var delegate:CategoriesViewModelDelegate?
    var selectedCategoryName: String?
    
    init(delegate: CategoriesViewModelDelegate, selectedCategoryName: String? = nil) {
        self.delegate = delegate
        self.selectedCategoryName = selectedCategoryName
        self.categories = getCategoryFromStore()
        bind()
    }
    
    func deleteCategory(index: Int) {
        
        let categoryviewModel = categories[index]
        do {
            try trackerCatStory.deleteCategory(TrackerCategory(name: categoryviewModel.categoryName, trackers: []))
        } catch {
            print("Не удалось удалить категорию")
        }
        self.categories = getCategoryFromStore()
    }
        
    private func getCategoryFromStore() -> [CategoryViewModel] {
        var categoryArray = [CategoryViewModel]()
        for category in trackerCatStory.trackerCategory {
            if category.name == selectedCategoryName {
                let categoryViewModel = CategoryViewModel(categoryName: category.name, categoryIsSelected: true)
                categoryArray.append(categoryViewModel)
            } else {
                let categoryViewModel = CategoryViewModel(categoryName: category.name, categoryIsSelected: false)
                categoryArray.append(categoryViewModel)
            }
        }
        return categoryArray
    }
    
    func selectCategory() {
        delegate?.updateSelectedCategory(name: selectedCategoryName)
    }
    
    func bind() {
        trackerCatStory.$trackerCategory.bind { [weak self] _ in
            self?.categories = self?.getCategoryFromStore() ?? []
        }
    }
    
}

//MARK: - Extension CategoryAddViewModelDelegate
//extension CategoriesViewModel: CategoryAddViewModelDelegate {
//    func changeCategory() {
//        self.categories = getCategoryFromStore()
//    }
//}
