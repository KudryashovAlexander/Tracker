//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Александр Кудряшов on 09.09.2023.
//

import Foundation

class CategoriesViewModel {
    
    @Observable
    private(set) var cateories = [CategoryViewModel]()
    
    private var trackerCatStory: TrackerCategoryStory
    
    init(trackerCatStory: TrackerCategoryStory = TrackerCategoryStory() ) {
        self.trackerCatStory = trackerCatStory
        self.cateories = getCategoryFromStore()
    }
    
    //Добавить функцию удаления категории
    private func deleteCategory(name: String) {
        //НАПИСАТЬ МЕТОД ПОПОЗЖЕ
        let categoryviewModel = CategoryViewModel(categoryName: name, categoryIsSelected: false)
        try! trackerCatStory.deleteCategory(TrackerCategory(name: categoryviewModel.categoryName, trackers: []))
    }
    
    //Добавить делегат для категори вью?
    
    private func getCategoryFromStore() -> [CategoryViewModel] {
        return trackerCatStory.trackerCategoryViewModel
    }
    
    
}
