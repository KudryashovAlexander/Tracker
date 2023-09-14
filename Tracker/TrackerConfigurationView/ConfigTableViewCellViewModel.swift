//
//  ConfigTableViewCellViewModel.swift
//  Tracker
//
//  Created by Александр Кудряшов on 13.09.2023.
//

import Foundation

class ConfigTableViewCellViewModel {
    
    @Observable
    private(set) var propertyName: String
    
    @Observable
    private(set) var selectedPoperty: String?
    
    init(propertyName: String, selectedPoperty: String? = nil) {
        self.propertyName = propertyName
        self.selectedPoperty = selectedPoperty
    }
    
    func changeSelectedProperty(_ text: String) {
        selectedPoperty = text
    }
    
    
    
}
