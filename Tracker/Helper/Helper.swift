//
//  Helper.swift
//  Tracker
//
//  Created by Александр Кудряшов on 11.08.2023.
//

import UIKit

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

// Для МОК Данных



let tracker1 = Tracker(name: "Погладить кота", color: .ypCS5, emojie: "😻")
let tracker2 = Tracker(name: "Приготовить поесть", color: .ypCS9, emojie: "🥦")
let homeWork = TrackerCategory(name: "Домашние дела",
                               trackers: [tracker1, tracker2])

let tracker3 = Tracker(name: "Поиграть на улице", color: .ypCS2, emojie: "🏓")
let goAway = TrackerCategory(name: "На улице",
                               trackers: [tracker3])

let tracker4 = Tracker(name: "Заяться спортом", color: .ypCS8, emojie: "🥇")
var tracker5 = Tracker(name: "Отслеживать питание", color: .ypCS10, emojie: "🍔")

let sportLife = TrackerCategory(name: "ЗОЖ",
                                trackers: [tracker4,tracker5])

let mokVisibaleCategory: [TrackerCategory] = [homeWork,goAway,sportLife]


