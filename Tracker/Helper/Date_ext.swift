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
    
    static let pickerDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.YY"
        return formatter
    }()
    
    

}

extension Date {

    var weekdayNameString: String {
        Formatter.weekdayName.string(from: self)
    }
    
    var dayMounthYearString: String {
        Formatter.pickerDateFormat.string(from: self)
    }
    
   
    
    func isAfter(_ date: Date = Date()) -> Bool {
        
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let selfComponents = calendar.dateComponents([.year, .month, .day], from: self)
        
        return calendar.date(from: selfComponents)! > calendar.date(from: dateComponents)!
    }
    
}
