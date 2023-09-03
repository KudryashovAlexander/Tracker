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
    
    func updateTrackerCoreData(_ tracker: Tracker) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData()
        trackerCoreData.name = tracker.name
        trackerCoreData.colorHex = tracker.color.hexStringFromColor()
        trackerCoreData.emojie = tracker.emojie
        trackerCoreData.scheduleString = tracker.schedule.daysOnString()
        trackerCoreData.id = tracker.id
        return trackerCoreData
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
