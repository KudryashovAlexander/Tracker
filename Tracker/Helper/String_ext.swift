//
//  String_ext.swift
//  Tracker
//
//  Created by Александр Кудряшов on 28.08.2023.
//

import UIKit

extension String {
    func firstCharOnly() -> String {
        return prefix(1).uppercased() + self.dropFirst()
    }
    
    func hexStringToUIColor() -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //Онбординг
    var onboardingLabel1: String { NSLocalizedString("onboarding.label1", comment: "Отслеживайте только то, что хотите") }
    var onboardingLabel2: String { NSLocalizedString("onboarding.label2", comment: "Даже если это не литры воды и йога") }
    var onboardingButton: String { NSLocalizedString("onboarding.button", comment: "Вот это технологии") }
    
    //ТрекерВью
    var mainTracker: String { NSLocalizedString("main.trackers", comment: "Трекеры") }
    var mainStatistic: String { NSLocalizedString("main.statistics", comment: "Статистика") }
    var mainFilter: String { NSLocalizedString("main.filter", comment: "Фильтры") }
    var mainEmptyLabel: String { NSLocalizedString("main.emptyLabel", comment: "Что будем отслеживать?") }
    var mainNoSearch: String { NSLocalizedString("main.notSearch", comment: "Ничего не найдено") }
    
    //Фильтры
    var filterAllTracker: String { NSLocalizedString("filter.alltracker", comment: "Все трекеры") }
    var filterTrackerToday: String { NSLocalizedString("filter.trackerToday", comment: "Трекеры на сегодня") }
    var filterComplated: String { NSLocalizedString("filter.complated", comment: "Завершенные") }
    var filterNotComplated: String { NSLocalizedString("filter.notComplated", comment: "Не завершенные") }
    
    //Новыйтрекервью
    var newTrackerTitle: String { NSLocalizedString("newtracker.title", comment: "Создание трекера") }
    var buttonAddTRacker: String { NSLocalizedString("button.addTracker", comment: "Привычка") }
    var buttonAddNotRegular: String { NSLocalizedString("button.addNotRegular", comment: "Нерегулярное событие") }
    
    //ТрекерКонфигуратионВью
    var newTrackerEditTitle: String { NSLocalizedString("trackerEdit.newTrackerTitle", comment: "Новая привычка") }
    var newNotRegularTitle: String { NSLocalizedString("trackerEdit.newNotRegularTitle", comment: "Новое нерегулярное событие") }
    var editTrackerTitle: String { NSLocalizedString("trackerEdit.editTitle", comment: "Редактирование привычки") }
    var trackerEditPlaceHolder: String { NSLocalizedString("trackerName.placeholder" , comment: "Введите название трекера") }
    var attenteionLabel: String { NSLocalizedString("attentionLabel", comment: "Ограничение 38 символов") }
    var categoryName: String { NSLocalizedString("category", comment: "Категория") }
    var scheduleName: String { NSLocalizedString("schedule", comment: "Расписание") }
    var emojiName: String { NSLocalizedString("emoji", comment: "Emoji") }
    var colorName: String { NSLocalizedString("color", comment: "Цвет") }
    
    //Button
    var buttonCreate: String { NSLocalizedString("button.create", comment: "Создать") }
    var buttonDelete: String { NSLocalizedString("button.delete", comment: "Удалить") }
    var buttonCansel: String { NSLocalizedString("button.cancel", comment: "Отменить") }
    var buttonReady: String { NSLocalizedString("button.ready", comment: "Готово") }
    var buttonAddCategory: String { NSLocalizedString("button.addCategory", comment: "Добавить категорию") }
    
    //Алерт
    var alertDeleteTracker: String { NSLocalizedString("alert.deleteTracker", comment: "Уверены что хотите удалить трекер?") }
    var alertDeleteCategory: String { NSLocalizedString("alert.category", comment: "Эта категория точно не нужна?") }
    
    //cell
    var cellPin: String { NSLocalizedString("cell.pin", comment: "Закрепить") }
    var cellUnpin: String { NSLocalizedString("cell.unpin", comment: "Открепить") }
    var cellEdit: String { NSLocalizedString("cell.edit", comment: "Редактировать") }
    var cellDelete: String { NSLocalizedString("cell.delete", comment: "Удалить") }
    
    //Категориявью
    var categoryEmptyLabel: String { NSLocalizedString("category.empty", comment: "Привычки и события можно объединить по смыслу") }
    var categoryChangeTitle: String { NSLocalizedString("category.changeTitle", comment: "Редактирование категории") }
    var categoryNewCategory: String { NSLocalizedString("category.newTitle", comment: "Новая категория") }
    
    var categoryPlaceHolder: String { NSLocalizedString("category.placeholder", comment: "Введите название категории" ) }
    
    //Статистика
    var statisticBestRecord: String { NSLocalizedString("statistic.bestPeriod", comment:"Лучший период") }
    var statisticPerfextDays: String { NSLocalizedString("statistic.perfectDays", comment: "Идеальные дни") }
    var statisticTrackerCompleted: String { NSLocalizedString("statistic.trackersCompleted", comment: "Трекеров завершено") }
    var statisticAverageValue: String { NSLocalizedString("statistic.averageValue", comment: "Среднее значение") }
    var statisticEmptyLabel: String { NSLocalizedString("statistic.empty", comment: "Анализировать пока нечего" ) }
}
