//
//  Schedule.swift
//  Tracker
//
//  Created by Александр Кудряшов on 07.08.2023.
//

import Foundation

struct ScheduleDay {
    let name: String
    let shortName: String
    var isOn: Bool = false
}

private var monday = ScheduleDay(name: "Понедельник", shortName: "Пн")
private var tuesday = ScheduleDay(name: "Вторник", shortName: "Вт")
private var wednesday = ScheduleDay(name: "Среда", shortName: "Ср")
private var thursday = ScheduleDay(name: "Четверг", shortName: "Чт")
private var friday = ScheduleDay(name: "Пятница", shortName: "Пт")
private var saturday = ScheduleDay(name: "Суббота", shortName: "Сб")
private var sunday = ScheduleDay(name: "Воскресенье", shortName: "Вс")



struct ScheduleTracker {
    var scheduleArray = [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
    
    mutating func changeSchedule(_ index:Int, isOn: Bool) {
        scheduleArray[index].isOn = isOn
    }
    
    func shortDays() -> String {
        var shorNames = String()
        
        for day in scheduleArray {
            var count = 0
            if day.isOn {
                shorNames = shorNames + day.shortName + " ,"
                count += 1
            }
            if count == 7 { return "Каждый день" }
        }
        if !shorNames.isEmpty { shorNames.removeLast(2) }
        return shorNames
    }
    
}
