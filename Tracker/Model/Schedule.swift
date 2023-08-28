//
//  Schedule.swift
//  Tracker
//
//  Created by Александр Кудряшов on 28.08.2023.
//

import Foundation
struct Schedule {
    var daysIsOn = [day1, day2, day3, day4, day5, day6, day7]
    
    var shortNameDay: [String] = {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru_RU")
        var shortdayOfWeek = calendar.shortWeekdaySymbols
        shortdayOfWeek.append(shortdayOfWeek[0])
        shortdayOfWeek.removeFirst()
        return shortdayOfWeek
    }()
    
    lazy var shortNameDayS: String = {
        var shortNames = String()
        for day in shortNameDay {
            var count = 0
            if daysIsOn[count].isOn {
                shortNames = shortNames + day + " ,"
                count += 1
            }
            if count == 6 { return "Каждый день" }
        }
        if !shortNames.isEmpty { shortNames.removeLast(2) }
        return shortNames
    }()
    
    lazy var dayOfWeek: [String] = {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru_RU")
        var dayOfWeek = calendar.weekdaySymbols
        dayOfWeek.append(dayOfWeek[0])
        dayOfWeek.removeFirst()
        var days = dayOfWeek.compactMap { dayString in
            dayString.firstCharOnly()
        }
        return days
    }()
}

struct WeekDay {
    var numberValue: Int
    var isOn: Bool
}

private var day1 = WeekDay(numberValue: 2, isOn: true)
private var day2 = WeekDay(numberValue: 3, isOn: true)
private var day3 = WeekDay(numberValue: 4, isOn: true)
private var day4 = WeekDay(numberValue: 5, isOn: false)
private var day5 = WeekDay(numberValue: 6, isOn: true)
private var day6 = WeekDay(numberValue: 7, isOn: false)
private var day7 = WeekDay(numberValue: 8, isOn: false)

