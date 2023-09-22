//
//  TrackerPinStore.swift
//  Tracker
//
//  Created by Александр Кудряшов on 21.09.2023.
//

import CoreData
import UIKit

enum TrackerPinStoreError: Error {
    case decodingErrorInvalidId
}

class TrackerPinStore: NSObject {
    
    static let shared = TrackerPinStore()
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerPinCoreData>!
    
    @Observable
    private(set) var trackersPin: [UUID] = []
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistantContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerPinCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerPinCoreData.id, ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
        getPinTracker()
    }
    
    private func getPinTracker() {
        trackersPin = {
            guard
                let object = self.fetchedResultsController.fetchedObjects,
                let trackersID = try? object.map({ try self.updateTrackerPin($0)})
            else {
                return []
            }
            return trackersID
        }()
    }
    
    private func updateTrackerPinCoreData(_ trackerPinCoreData: TrackerPinCoreData, id: UUID ) {
        trackerPinCoreData.id = id
    }
    
    private func updateTrackerPin(_ trackerPinCoreData: TrackerPinCoreData) throws -> UUID {
        guard let id = trackerPinCoreData.id else {
            throw TrackerPinStoreError.decodingErrorInvalidId
        }
        return id
    }
    
    func addOrDeletePin(id: UUID) throws {
        guard let object = self.fetchedResultsController.fetchedObjects else { return }
        for tracker in object {
            if tracker.id == id {
                context.delete(tracker)
                try context.save()
                return
            }
        }
        let trackerPin = TrackerPinCoreData(context: context)
        updateTrackerPinCoreData(trackerPin, id: id)
        try context.save()
    }
    
    func trackerIsPin(id: UUID) -> Bool {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
            return false
        }
        let trackerContain = fetchedObjects.filter { $0.id == id }
        return !trackerContain.isEmpty
    }
    
}
//MARK: - Extension TrackerRecordDelegate
extension TrackerPinStore:NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        getPinTracker()
    }
    
}
