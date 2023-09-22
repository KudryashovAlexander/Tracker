//
//  TrackerViewModel.swift
//  Tracker
//
//  Created by Александр Кудряшов on 20.09.2023.
//

import UIKit

protocol TrackerViewModelProtocol: AnyObject {
    func updateTrackerRecord(id: UUID)
}

class TrackerViewModel {
    
    @Observable private(set) var name: String
    @Observable private(set) var color: UIColor
    @Observable private(set) var emojie: String
    
    @Observable private(set) var pinTracker: Bool
    @Observable private(set) var countDay: Int
    @Observable private(set) var pressButton: Bool
    let id: UUID
    private weak var delegate:TrackerViewModelProtocol?
    
    init(name: String, color: UIColor, emojie: String, pinTracker: Bool, countDay: Int, pressButton: Bool, id: UUID, delegate:TrackerViewModelProtocol? ) {
        self.name = name
        self.color = color
        self.emojie = emojie
        self.pinTracker = pinTracker
        self.countDay = countDay
        self.pressButton = pressButton
        self.id = id
        self.delegate = delegate
    }

    
    func changeRecord() {
        delegate?.updateTrackerRecord(id: id)
    }
    
}
