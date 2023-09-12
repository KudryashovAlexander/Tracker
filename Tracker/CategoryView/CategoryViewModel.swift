//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Александр Кудряшов on 09.09.2023.
//

import Foundation

struct CategoryViewModel {
    private(set) var categoryName: String
    private(set) var categoryIsSelected: Bool
    
    init(categoryName: String, categoryIsSelected: Bool = false) {
        self.categoryName = categoryName
        self.categoryIsSelected = categoryIsSelected
    }
}
