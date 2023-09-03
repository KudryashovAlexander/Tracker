//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Александр Кудряшов on 02.09.2023.
//

import Foundation
import CoreData

enum TrackerCategoryError: Error {
    case decodingErrorInvalidName
    case decodingErrorInvalidTrackers
    case convertErrorTrackerCategoryTrackersCoreData
}

class TrackerCategoryStory: NSObject {
    
    private var trackerStore = TrackerStore()
    
    func updateTrackerCategoryCoreData( _ trackerCategory: TrackerCategory) -> TrackerCategoryCoreData {
        let trackerCategoryCoreData = TrackerCategoryCoreData()
        let trackerSet = NSSet()
        
        let trackersCoreData = trackerCategory.trackers.map({trackerStore.updateTrackerCoreData($0)})
        trackerSet.addingObjects(from: trackersCoreData)
        
        trackerCategoryCoreData.name = trackerCategory.name
        trackerCategoryCoreData.trackers = trackerSet
        
        return trackerCategoryCoreData
    }
    
    func updateTrackerCategory( _ trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let name = trackerCategoryCoreData.name else {
            throw TrackerCategoryError.decodingErrorInvalidName
        }
        guard let trackersCoreDataSet = trackerCategoryCoreData.trackers as? Set<TrackerCoreData> else {
            throw TrackerCategoryError.decodingErrorInvalidTrackers
        }
        
        var trackers = [Tracker]()
        for trackerCoreData in trackersCoreDataSet {
            do {
                try trackers.append(trackerStore.updateTracker(trackerCoreData))
            }
            catch {
                throw TrackerCategoryError.convertErrorTrackerCategoryTrackersCoreData
            }
        }
        return TrackerCategory(name: name,
                               trackers: trackers)
    }
    
    
    
}

