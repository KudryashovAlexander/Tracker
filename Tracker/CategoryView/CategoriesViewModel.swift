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
    private var trackerCatStory = TrackerCategoryStory()
    
    //Подключить TrackerCategoryStore
    
    //Добавить функцию для добавления Категории
    
    //Добавить функцию удаления категории
    
    //Добавить делегат для категори вью?
    
    private func getCategoryFromStore() -> [CategoryViewModel] {
        return trackerCatStory.trackerCategoryViewModel
    }
    
    
}
