//
//  Date_ext.swift
//  Tracker
//
//  Created by Александр Кудряшов on 25.08.2023.
//

import Foundation

extension Formatter {

    static let weekdayName: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "E"
        return formatter
    }()

}

extension Date {
    
    func isAfter(_ date: Date = Date()) -> Bool {
        
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let selfComponents = calendar.dateComponents([.year, .month, .day], from: self)
        
        return calendar.date(from: selfComponents)! > calendar.date(from: dateComponents)!
    }
    
}
