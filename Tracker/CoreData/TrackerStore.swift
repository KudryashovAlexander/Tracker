//
//  TrackerStore.swift
//  Tracker
//
//  Created by Александр Кудряшов on 02.09.2023.
//

import CoreData
import UIKit

enum TrackerStoreError: Error {
    case decodingErrorInvalidName
    case decodingErrorInvalidColorHex
    case decodingErrorInvalidEmojie
    case decodingErrorInvalidSchedule
    case decodingErrorInvalidId
    case invalidChangeTracker
}

class TrackerStore: NSObject {
    
    static let shared = TrackerStore()
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    
    @Observable
    private(set) var trackers: [Tracker] = []
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistantContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
        getTracker()
    }
    
    private func getTracker() {
        trackers = { guard
            let object = self.fetchedResultsController.fetchedObjects,
            let trackers = try? object.map({ try self.updateTracker($0)})
            else { return [] }
            return trackers
        }()
    }
    
    func addTracker(at newTracker: Tracker) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        try updateTrackerCoreData(trackerCoreData, with: newTracker)
        try context.save()
        return trackerCoreData
    }
    
    func deleteTracker(at trackerID: UUID) throws {
        guard let object = self.fetchedResultsController.fetchedObjects else { return }
        for trackerCoreData in object {
            if trackerCoreData.id == trackerID {
                context.delete(trackerCoreData)
                try context.save()
                break
            }
        }
    }
    
    func changeTracker(oldTracker: Tracker, newTracker: Tracker) {
        let trackerIDString = oldTracker.id.uuidString
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let predicate = NSPredicate(format: "%K == %@", (\TrackerCoreData.id)._kvcKeyPathString!, trackerIDString)
        request.predicate = predicate
        do {
            let results = try context.fetch(request)
            for trackerCoreData in results {
                if trackerCoreData.id == oldTracker.id {
                    trackerCoreData.name = newTracker.name
                    trackerCoreData.emojie = newTracker.emojie
                    trackerCoreData.colorHex = newTracker.color.hexStringFromColor()
                    trackerCoreData.scheduleString = newTracker.schedule.daysOnString()
                    try context.save()
                }
            }
            
        } catch {
            print(TrackerStoreError.invalidChangeTracker)
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

//MARK: - Extension NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        getTracker()
    }
    
}
