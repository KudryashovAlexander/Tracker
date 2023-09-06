//
//  Tracker.swift
//  Tracker
//
//  Created by Александр Кудряшов on 07.08.2023.
//

import UIKit

struct Tracker {
    let name: String
    let color: UIColor
    let emojie: String
    let schedule: Schedule
    let id: UUID
    
    init(name: String,
         color: UIColor,
         emojie: String,
         schedule: Schedule = Schedule(),
         id:UUID = UUID() ) {
        self.name = name
        self.color = color
        self.emojie = emojie
        self.schedule = schedule
        self.id = id
    }
}

