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
    
    static let pickerDateFormat: DateFormatter = { //Можно подключить только для верисий айос 15 и новее
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

}
