//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Александр Кудряшов on 09.09.2023.
//

import Foundation

struct CategoryViewModel {
    
    @Observable
    private(set) var categoryName: String?
    
    @Observable
    private(set) var categoryIsSelected: Bool?
}
