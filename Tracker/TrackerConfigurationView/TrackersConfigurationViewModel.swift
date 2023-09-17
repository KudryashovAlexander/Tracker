
//  TrackerConfigurationViewModel.swift
//  Tracker
//
//  Created by Александр Кудряшов on 15.09.2023.
//

import UIKit

enum TrackerType {
    case regular
    case notRegular
}

enum TrackerConfigurationType {
    case add
    case change
}

final class TrackerConfigurationViewModel {
    
    private let trackerType: TrackerType
    private let trackerConfigurationType: TrackerConfigurationType
    private let tracker: Tracker?
    private let trackerCategory: TrackerCategory?
    
    var viewName = String()
    private var recordIsHidden: Bool = false
    private var daysRecord: Int?
    var trackerName: String? {
        didSet {
            checkCount()
            checkTrackerData()
        }
    }
    var trackerSchedule = Schedule() {
        didSet {
            guard let daysIsOn = calendarHelper.shortNameSchedule(at: trackerSchedule.daysOn) else {
                scheduleViewModel.changeSelectedProperty(nil)
                checkTrackerData()
                return
            }
            scheduleViewModel.changeSelectedProperty(daysIsOn)
            checkTrackerData()
        }
    }
    
    var categoryName: String? {
        didSet {
            categoryViewModel.changeSelectedProperty(categoryName)
            checkTrackerData()
        }
    }
    var trackerEmodji: String? {
        didSet {
            checkTrackerData()
        }
    }
    var trackerColor: UIColor? {
        didSet {
            checkTrackerData()
        }
    }
    
    @Observable
    var attentionIsHidden: Bool = true
    
    @Observable
    var buttonIsEnabled: Bool = false
    
    private let categoryViewModel = ConfigTableViewCellViewModel(propertyName: "Категория", selectedPoperty: nil)
    private let scheduleViewModel = ConfigTableViewCellViewModel(propertyName: "Расписание", selectedPoperty: nil)
    
    private let trackerRecordStore = TrackerRecordStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let calendarHelper = CalendarHelper()
    
    var tableViewCellViewModel: [ConfigTableViewCellViewModel] = []
    
    init(
        trackerType: TrackerType,
        trackerConfigurationType: TrackerConfigurationType,
        tracker:Tracker? = nil,
        trackerCategory: TrackerCategory? = nil
    ) {
        self.trackerType = trackerType
        self.trackerConfigurationType = trackerConfigurationType
        self.tracker = tracker
        self.trackerCategory = trackerCategory
        
        viewNameSupport()
        recordSupport()
        trackerSupport()
        trackerScheduleSupport()
        tableViewCellViewModelSupport()
        
        checkCount()
        checkTrackerData()
    }
    
    private func viewNameSupport() {
        switch (trackerType,trackerConfigurationType) {
        case (.regular,.add):
            viewName = "Новая привычка"
        case (.notRegular, .add):
            viewName = "Новое нерегулярное событие"
        case ( _ , .change):
            viewName = "Редактировоание привычки"
        }
    }
    
    private func recordSupport() {
        switch trackerConfigurationType {
        case .add:
            recordIsHidden = true
            daysRecord = nil
        case .change:
            recordIsHidden = false
            daysRecord = recordDays()
        }
    }
    
    private func trackerSupport() {
        switch trackerConfigurationType {
        case .add:
            trackerName = nil
            trackerEmodji = nil
            trackerColor = nil
        case .change:
            trackerName = tracker?.name
            trackerEmodji = tracker?.emojie
            trackerColor = tracker?.color
        }
    }
    
    private func trackerScheduleSupport() {
        switch (trackerType,trackerConfigurationType) {
        case (.notRegular, _ ):
            trackerSchedule.allDayOn()
        case (.regular,.change):
            guard let tracker = tracker else { break }
            trackerSchedule = tracker.schedule
        case (.regular,.add):
            trackerSchedule = Schedule()
        }
    }
    
    private func tableViewCellViewModelSupport() {
        switch (trackerType,trackerConfigurationType) {
            
        case (.regular,.add):
            tableViewCellViewModel = [categoryViewModel,scheduleViewModel]
            
        case (.notRegular,.add):
            tableViewCellViewModel = [categoryViewModel]
            
        case (.regular,.change):
            let categoryName = trackerCategory?.name
            categoryViewModel.changeSelectedProperty(categoryName)
            
            let scheduleString = calendarHelper.shortNameSchedule(at: trackerSchedule.daysOn)
            scheduleViewModel.changeSelectedProperty(scheduleString)
            
            tableViewCellViewModel = [categoryViewModel,scheduleViewModel]
            
        case (.notRegular,.change):
            let categoryName = trackerCategory?.name
            categoryViewModel.changeSelectedProperty(categoryName)
            
            tableViewCellViewModel = [categoryViewModel]
        }
    }
    
    private func recordDays() -> Int {
        guard let tracker = tracker else { return 0 }
        return trackerRecordStore.countDay(id: tracker.id)
    }
    
    private func checkCount() {
        guard let trackerName = trackerName else { return }
        if trackerName.count > 38 {
            attentionIsHidden = false
        } else {
            attentionIsHidden = true
        }
    }
    
    private func checkTrackerData() {
        switch trackerType {
        case .regular:
            if trackerName != nil, categoryName != nil, trackerEmodji != nil, trackerColor != nil, !trackerSchedule.daysOn.isEmpty, attentionIsHidden == true {
                buttonIsEnabled = true
            } else {
                buttonIsEnabled = false
            }
        case .notRegular:
            if trackerName != nil, categoryName != nil, trackerEmodji != nil, trackerColor != nil, attentionIsHidden == true {
                buttonIsEnabled = true
            } else {
                buttonIsEnabled = false
            }
        }
    }
    
    private func nextView() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration") }
        let tabBar = TabBarController()
        window.rootViewController = tabBar
    }
    
    func pressButton() {
        switch trackerConfigurationType {
        case .add:
            guard let trackerName = trackerName,
                  let trackerColor = trackerColor,
                  let trackerEmodji = trackerEmodji,
                  let categoryName = categoryName else { return }
    
            let tracker = Tracker(name: trackerName,
                                  color: trackerColor,
                                  emojie: trackerEmodji,
                                  schedule: trackerSchedule,
                                  id: UUID())
           
            do {
                try trackerCategoryStore.addTracker(at: tracker, categoryName: categoryName)
                nextView()
            } catch {
                print("Ошибка в сохранении трекера")
            }
        case .change:
            
            guard let trackerName = trackerName,
                  let trackerColor = trackerColor,
                  let trackerEmodji = trackerEmodji,
                  let categoryName = categoryName,
                  let tracker = tracker,
                  let trackerCategory = trackerCategory else { return }
            
            let newTracker = Tracker(name: trackerName,
                                  color: trackerColor,
                                  emojie: trackerEmodji,
                                  schedule: trackerSchedule,
                                  id: UUID())
            do {
                try trackerCategoryStore.changeTracker(oldTracker: tracker,
                                                       oldCategoryName: trackerCategory.name,
                                                       newTracker: newTracker,
                                                       newCategoryName: categoryName)
                nextView()
            } catch {
                print("Ошибка в сохранении трекера")
            }
            
        }
    }
    
}

//MARK: - Extension ScheduleViewControllerProtocol
extension TrackerConfigurationViewModel: ScheduleViewControllerProtocol {
    func updateSchedule(_ newSchedule: Schedule) {
        trackerSchedule = newSchedule
    }
}

//MARK: - Extension CategoriesViewModelDelegate
extension TrackerConfigurationViewModel:CategoriesViewModelDelegate {
    
    func updateSelectedCategory(name: String?) {
        categoryName = name
    }
}