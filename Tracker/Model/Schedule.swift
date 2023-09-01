//
//  Schedule.swift
//  Tracker
//
//  Created by Александр Кудряшов on 28.08.2023.
//

import Foundation

enum WeekDay: Int {
    case monday = 2
    case thusdey = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
}

struct Schedule {
    var daysOn = Set<WeekDay.RawValue>()
}
