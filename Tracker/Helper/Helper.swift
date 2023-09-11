//
//  Helper.swift
//  Tracker
//
//  Created by Александр Кудряшов on 11.08.2023.
//

import UIKit

struct UserProfile {
    static let joinSuccess = "JoinSuccess"
}

struct EmojieCollection {
    let name = "Emoji"
    let array: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                           "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                           "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
}
 
struct ColorCollection {
    let name = "Цвет"
    let array: [UIColor] = [.ypCS1, .ypCS2, .ypCS3, .ypCS4, .ypCS5, .ypCS6,
                            .ypCS7, .ypCS8, .ypCS9, .ypCS10, .ypCS11, .ypCS12,
                            .ypCS13, .ypCS14, .ypCS15, .ypCS16, .ypCS17, .ypCS18]
}

// Для использования МОК данных в без Кор даты
/*
let monday = WeekDay.monday.rawValue
let thusdey = WeekDay.thusdey.rawValue
let wednesday = WeekDay.wednesday.rawValue
let thursday = WeekDay.thursday.rawValue
let friday = WeekDay.friday.rawValue
let saturday = WeekDay.saturday.rawValue
let sunday = WeekDay.sunday.rawValue

let schedule1:Set<WeekDay.RawValue> = [monday, thusdey, wednesday, thursday ]

let schedule2:Set<WeekDay.RawValue> = [friday, saturday, sunday, monday]

let schedule3 :Set<WeekDay.RawValue> = [thusdey, thursday, saturday, wednesday]


let tracker1 = Tracker(name: "Погладить кота", color: .ypCS5, emojie: "😻", schedule: Schedule(daysOn: schedule1))
let tracker2 = Tracker(name: "Приготовить поесть", color: .ypCS9, emojie: "🥦", schedule: Schedule(daysOn: schedule3))

let homeWork = TrackerCategory(name: "Домашние дела",
                               trackers: [tracker1, tracker2])

let tracker3 = Tracker(name: "Поиграть на улице", color: .ypCS2, emojie: "🏓", schedule: Schedule(daysOn: schedule2))
let goAway = TrackerCategory(name: "На улице",
                               trackers: [tracker3])

let tracker4 = Tracker(name: "Заяться спортом", color: .ypCS8, emojie: "🥇", schedule: Schedule(daysOn: schedule3))
var tracker5 = Tracker(name: "Отслеживать питание", color: .ypCS10, emojie: "🍔", schedule: Schedule(daysOn: schedule1))

let sportLife = TrackerCategory(name: "ЗОЖ",
                                trackers: [tracker4,tracker5])

let mokVisibaleCategory: [TrackerCategory] = [homeWork,goAway,sportLife]
*/

