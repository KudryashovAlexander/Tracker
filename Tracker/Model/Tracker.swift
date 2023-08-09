//
//  Tracker.swift
//  Tracker
//
//  Created by Александр Кудряшов on 07.08.2023.
//

import UIKit

struct Tracker {
    var name: String
    var color: UIColor
    var emojie: String
    var schedule = ScheduleTracker()
    let id = UUID()
    
    init(name: String, color: UIColor, emojie: String) {
        self.name = name
        self.color = color
        self.emojie = emojie
    }
}
