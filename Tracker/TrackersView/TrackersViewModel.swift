//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Александр Кудряшов on 21.09.2023.
//

import UIKit

class TrackersViewModel {
    
    private var categories: [TrackerCategory] {
        didSet {
            changePinCategories()
        }
    }

    private var trackersPinId: [UUID] {
        didSet {
            changePinCategories()
        }
    }
    
    private var pinCategories: [TrackerCategory] = [] {
        didSet {
            filterText()
        }
    }
    
    private var trackerRecord: [TrackerRecord] {
        didSet {
            filterText()
        }
    }
    
    private var visibleCategories: [TrackerCategory] = [] {
        didSet {
            changeDateOrText()
            convertCategoriesToViewModel()
        }
    }
    
    @Observable
    private(set) var visibleViewModels: [TrackerCategoryViewModel] = []

    private var searchText: String? {
        didSet{
            filterText()
            changeDateOrText()
        }
    }
    private var currentDate: Date {
        didSet {
            filterText()
            changeDateOrText()
        }
    }
    
    @Observable
    private(set) var collectionEmptyOrNosearch: Bool?
    var selectedFilter: Int = 1
    private var filterDaysOn: Bool = true
    private var filterRecordOn: Bool? = nil
    
    private let calendarHelper = CalendarHelper()
    private var trackerCategoryStore = TrackerCategoryStore.shared
    private var trackerRecordStore = TrackerRecordStore.shared
    private let trackerPinStore = TrackerPinStore.shared
    private let trackerStore = TrackerStore.shared
    private let analyticsService = AnalyticsService()
    
    
    init(searchText: String? = nil,
         trackerCategoryStore: TrackerCategoryStore = TrackerCategoryStore.shared,
         trackerRecordStore: TrackerRecordStore = TrackerRecordStore.shared) {
        self.searchText = searchText
        self.currentDate = calendarHelper.dateWithoutTime(Date())
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerRecordStore = trackerRecordStore
        
        self.categories = trackerCategoryStore.trackerCategory
        self.trackerRecord = trackerRecordStore.trackerRecords
        self.trackersPinId = trackerPinStore.trackersPin
        
        bind()
        changePinCategories()
        filterText()
        convertCategoriesToViewModel()
    }
    
    private func bind() {
        trackerRecordStore.$trackerRecords.bind { [weak self] newTrackerRecord in
            self?.trackerRecord = newTrackerRecord
        }
        
        trackerCategoryStore.$trackerCategory.bind { [weak self] newCategorios in
            self?.categories = newCategorios
        }
        
        trackerPinStore.$trackersPin.bind { [weak self] newPintrackers in
            self?.trackersPinId = newPintrackers
        }
    }
    
    func searchText(text: String?) {
        searchText = text
    }
    
    func changeDate(_ newDate: Date) {
        currentDate = calendarHelper.dateWithoutTime(newDate)
    }
    
    private func filterText() {
        
        let filterText = (searchText ?? "").lowercased()
        let filterWeekDay = calendarHelper.calendarUse.component(.weekday, from: currentDate)
        
        visibleCategories = pinCategories.compactMap({ category in
            let trackers = category.trackers.filter { tracker in
                if filterDaysOn {
                    let dateCondition = tracker.schedule.daysOn.contains(filterWeekDay)
                    let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                    
                    if filterRecordOn == true {
                        let recordCondition = trackerRecordStore.dayIsDone(id: tracker.id, date: currentDate)
                        return dateCondition && textCondition && recordCondition
                    }
                    
                    if filterRecordOn == false {
                        let recordCondition = !trackerRecordStore.dayIsDone(id: tracker.id, date: currentDate)
                        return dateCondition && textCondition && recordCondition
                    }
                    
                    return dateCondition && textCondition
                } else {
                    let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                    return textCondition
                }
            }
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(name: category.name, trackers: trackers)
        })
    }
    
    private func changeDateOrText() {
        if !visibleCategories.isEmpty {
            collectionEmptyOrNosearch = nil
            return
        }
        if visibleCategories.isEmpty, searchText != nil {
            collectionEmptyOrNosearch = true
            return
        }
        if visibleCategories.isEmpty, searchText == nil {
            collectionEmptyOrNosearch = false
            return
        }
    }
    
    private func changePinCategories() {
        if trackersPinId.isEmpty {
            pinCategories = categories
            return
        }
        var pinTrackers = [Tracker]()
        var newTrackerCategory = [TrackerCategory]()
        
        for category in categories {
            var newTrackers = category.trackers
            var index = 0
            for tracker in category.trackers {
                for id in trackersPinId {
                    if tracker.id == id {
                        pinTrackers.append(tracker)
                        newTrackers.remove(at: index)
                    }
                }
                index += 1
            }
            let newCategory = TrackerCategory(name: category.name, trackers: newTrackers)
            newTrackerCategory.append(newCategory)
        }
        
        if !pinTrackers.isEmpty {
            let pinTrackerCategory = TrackerCategory(name: "Закрепленные", trackers: pinTrackers)
            newTrackerCategory.insert(pinTrackerCategory, at: 0)
        }
        pinCategories = newTrackerCategory
    }

    
    private func convertCategoriesToViewModel() {
        visibleViewModels = visibleCategories.map({convertCategoryToViewModel($0)})
    }
    
    private func convertCategoryToViewModel(_ trackerCategory: TrackerCategory) -> TrackerCategoryViewModel {
        return TrackerCategoryViewModel(name: trackerCategory.name,
                                        trackers: trackerCategory.trackers.map({convertTrackersToViewModel($0)})
        )
    }
    
    
    private func convertTrackersToViewModel(_ tracker: Tracker) -> TrackerViewModel{
        return TrackerViewModel(name: tracker.name,
                                color: tracker.color,
                                emojie: tracker.emojie,
                                pinTracker: trackerPinStore.trackerIsPin(id: tracker.id),
                                countDay: trackerRecordStore.countDay(id: tracker.id),
                                pressButton: trackerRecordStore.dayIsDone(id: tracker.id, date: currentDate),
                                id:tracker.id,
                                delegate: self)
    }

    
    func pinTracker(id: UUID) {
        do {
            try trackerPinStore.addOrDeletePin(id: id)
        } catch {
            print("Ошибка в закреплении")
        }
        
    }
    
    func changeTracker(id: UUID) -> (Tracker?,TrackerCategory?) {
        for trackerCategory in categories {
            for tracker in trackerCategory.trackers {
                if tracker.id == id {
                    return (tracker, trackerCategory)
                }
            }
        }
        analyticsService.report(event: "click_Main_Edit", params: ["Edit" : 1])
        return (nil,nil)
    }
    
    func deleteTracker(id: UUID) {
        do {
            try trackerStore.deleteTracker(at: id)
        } catch {
            print("Не удалось удалить трекер")
        }
    }
    
}

//MARK: - Extension TrackerViewModelProtocol
extension TrackersViewModel: TrackerViewModelProtocol {
    func updateTrackerRecord(id: UUID) {
        if currentDate.isAfter() {
            return
        }
        do{
            try trackerRecordStore.changeRecord(TrackerRecord(id: id, date: currentDate))
            analyticsService.report(event: "click_main_track", params: ["track" : 1])
        } catch {
            print("Ошибка в изменении трекер рекорда")
        }
    }
}

//MARK: - Extension TrackerFilterViewControllerDelegate
extension TrackersViewModel: TrackerFilterViewControllerDelegate {
    func changeFilter(newFilter: Int) {
        switch newFilter{
        case 0:
            filterDaysOn = false
            filterRecordOn = nil
        case 1:
            filterDaysOn = true
            filterRecordOn = nil
        case 2:
            filterDaysOn = true
            filterRecordOn = true
        case 3:
            filterDaysOn = true
            filterRecordOn = false
        default:
            break
        }
        selectedFilter = newFilter
        filterText()
    }
}

