//
//  CalendarHelper.swift
//  Tracker
//
//  Created by Александр Кудряшов on 01.09.2023.
//

import Foundation


class CalendarHelper {
    
    var calendarUse: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        calendar.locale = Locale(identifier: "ru_RU")
        calendar.timeZone = TimeZone(secondsFromGMT: 3 * 60 * 60)!
        return calendar
    }()
    
    func dateWithoutTime(_ date: Date) -> Date {
        let dateComponents = self.calendarUse.dateComponents([.year, .month, .day], from: date)
        return calendarUse.date(from: dateComponents) ?? date
    }
    
    lazy var dayNumber:[Int] = {
        return [2,3,4,5,6,7,1]
    }()
    
    lazy var dayNameOfWeek: [String] = {
        var dayOfWeek = calendarUse.weekdaySymbols
        dayOfWeek.append(dayOfWeek[0])
        dayOfWeek.removeFirst()
        var days = dayOfWeek.compactMap { dayString in
            dayString.firstCharOnly()
        }
        return days
    }()
    
    lazy var shortNameAllDay: [String] = {
        var shortdayOfWeek = calendarUse.shortWeekdaySymbols
        shortdayOfWeek.append(shortdayOfWeek[0])
        shortdayOfWeek.removeFirst()
        return shortdayOfWeek
    }()
    
    func shortNameSchedule(at days: Set<WeekDay.RawValue>) -> String? {
        if days.isEmpty {
            return nil
        }
        
        if days.count == 7 {
            return "Каждый день"
        }
        
        var days = days.sorted()
        if days.first == 1 {
            days.remove(at: 0)
            days.append(1)
        }
                
        var shortNames = String()

        for day in days {
            var index = 0
            for dayofWeek in dayNumber {
                if day == dayofWeek {
                    shortNames = shortNames + shortNameAllDay[index] + ", "
                }
                index += 1
            }
        }
        shortNames.removeLast(2)
        return shortNames
    }
    
}
