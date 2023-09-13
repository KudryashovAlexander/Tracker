//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Александр Кудряшов on 09.09.2023.
//

import Foundation

final class CategoriesViewModel {
    
    @Observable
    private(set) var cateories = [CategoryViewModel]()
    
    private var trackerCatStory: TrackerCategoryStory
    
    init(trackerCatStory: TrackerCategoryStory = TrackerCategoryStory() ) {
        self.trackerCatStory = trackerCatStory
        self.cateories = getCategoryFromStore()
    }
    
    //Добавить функцию удаления категории
    func deleteCategory(index: Int) {
        
        let categoryviewModel = cateories[index]
        try! trackerCatStory.deleteCategory(TrackerCategory(name: categoryviewModel.categoryName, trackers: []))
        self.cateories = getCategoryFromStore()
    }
    
    //Добавить делегат для категори вью?
    
    private func getCategoryFromStore() -> [CategoryViewModel] {
        return trackerCatStory.trackerCategoryViewModel
    }
    
}

//MARK: - Extension CategoryAddViewModelDelegate
extension CategoriesViewModel: CategoryAddViewModelDelegate {
    func changeCategory() {
        self.cateories = getCategoryFromStore()
    }
}
