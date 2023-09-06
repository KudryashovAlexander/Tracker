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
    var daysOn: Set<WeekDay.RawValue>
    
    init(daysOn: Set<WeekDay.RawValue> = Set<WeekDay.RawValue>()) {
        self.daysOn = daysOn
    }
    
    init(numberDaysString: String) {
        let array = numberDaysString.compactMap({WeekDay.RawValue(String($0))})
        self.daysOn = Set(array)
    }
    
    func daysOnString() -> String {
       return daysOn.map({String($0)}).reduce("",+)
    }
    
}
