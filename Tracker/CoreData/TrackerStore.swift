//
//  TrackerStore.swift
//  Tracker
//
//  Created by Александр Кудряшов on 02.09.2023.
//

import UIKit
import CoreData

enum TrackerStoreError: Error {
    case decodingErrorInvalidName
    case decodingErrorInvalidColorHex
    case decodingErrorInvalidEmojie
    case decodingErrorInvalidSchedule
    case decodingErrorInvalidId
}

class TrackerStore: NSObject {
    
    private let context: NSManagedObjectContext
    private var trackerRecordStore = TrackerRecordStore()
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistantContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
    }
    
    func addTracker(at newTracker: Tracker) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        try updateTrackerCoreData(trackerCoreData, with: newTracker)
        try context.save()
        return trackerCoreData
    }
    
    func deleteTracker(at tracker: Tracker) throws {
        let fetchRequest = TrackerCoreData.fetchRequest()
        let object = try context.fetch(fetchRequest)
        for trackerCoreData in object {
            if trackerCoreData.id == tracker.id {
                context.delete(trackerCoreData)
                try context.save()
                try trackerRecordStore.deleteTrackerRecord(tracker.id) 
                break
            }
        }
    }
    
    func deleteTrackerCoreData(_ trackerCoreData: TrackerCoreData) throws {
        context.delete(trackerCoreData)
        try context.save()
    }
    
    private func updateTrackerCoreData(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) throws {
        trackerCoreData.name = tracker.name
        trackerCoreData.colorHex = tracker.color.hexStringFromColor()
        trackerCoreData.emojie = tracker.emojie
        trackerCoreData.scheduleString = tracker.schedule.daysOnString()
        trackerCoreData.id = tracker.id
    }
    
    func updateTracker(_ trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let name = trackerCoreData.name else {
            throw TrackerStoreError.decodingErrorInvalidName
        }
        guard let colorHex = trackerCoreData.colorHex else {
            throw TrackerStoreError.decodingErrorInvalidColorHex
        }
        guard let emojie = trackerCoreData.emojie else {
            throw TrackerStoreError.decodingErrorInvalidEmojie
        }
        guard let scheduleString = trackerCoreData.scheduleString else {
            throw TrackerStoreError.decodingErrorInvalidSchedule
        }
        guard let id = trackerCoreData.id else {
            throw TrackerStoreError.decodingErrorInvalidId
        }
        
        return Tracker(name: name,
                       color: colorHex.hexStringToUIColor(),
                       emojie: emojie,
                       schedule: Schedule(numberDaysString: scheduleString),
                       id: id)
    }
    
}
