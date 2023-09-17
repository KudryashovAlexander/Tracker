//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Александр Кудряшов on 09.09.2023.
//

import Foundation

class CategoryViewModel {
    
    @Observable
    private(set) var categoryName: String
    
    @Observable
    private(set) var categoryIsSelected: Bool
    
    init(categoryName: String, categoryIsSelected: Bool = false) {
        self.categoryName = categoryName
        self.categoryIsSelected = categoryIsSelected
    }
    
    func selectedCategory(select: Bool) {
        self.categoryIsSelected = select
    }
    
}
