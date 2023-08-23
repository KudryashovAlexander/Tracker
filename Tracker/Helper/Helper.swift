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


struct PropertyTracker {
    let name: String
    func propertyViewController() {
    }
}

let categoryName = PropertyTracker(name: "Категория")
let scheduleName = PropertyTracker(name: "Расписание")


