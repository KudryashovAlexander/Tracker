//
//  CalendarHelper.swift
//  Tracker
//
//  Created by Александр Кудряшов on 01.09.2023.
//

import Foundation


class CalendarHelper {
    
    var calendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        calendar.locale = Locale(identifier: "ru_RU")
        calendar.timeZone = TimeZone(secondsFromGMT: 3 * 60 * 60)!
        return calendar
    }()
    
    lazy var dayNumber:[Int] = {
        return [2,3,4,5,6,7,1]
    }()
    
    lazy var dayNameOfWeek: [String] = {
        var dayOfWeek = calendar.weekdaySymbols
        dayOfWeek.append(dayOfWeek[0])
        dayOfWeek.removeFirst()
        var days = dayOfWeek.compactMap { dayString in
            dayString.firstCharOnly()
        }
        return days
    }()
    
    lazy var shortNameAllDay: [String] = {
        var shortdayOfWeek = calendar.shortWeekdaySymbols
        shortdayOfWeek.append(shortdayOfWeek[0])
        shortdayOfWeek.removeFirst()
        return shortdayOfWeek
    }()
    
    func shortNameSchedule(at days: Set<WeekDay>) -> String {
        if days.isEmpty {
            return ""
        }
        
        if days.count == 7 {
            return "Каждый день"
        }
        
        var daysNumber = days.compactMap { Weekday in
            Weekday.rawValue
        }
        
        var shortNames = String()

        for day in daysNumber {
            for dayofWeek in dayNumber {
                var index = 0
                if day == dayofWeek {
                    shortNames = shortNames + shortNameAllDay[index] + " ,"
                }
                index += 1
            }
        }
        shortNames.removeLast(2)
        return shortNames
    }
    
}
