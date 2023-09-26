//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Александр Кудряшов on 02.09.2023.
//

import CoreData
import UIKit

enum TrackerRecordError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidDate
    case changeErrorUpdate
    case changeErrorMove
}

class TrackerRecordStore: NSObject {
    
    static let shared = TrackerRecordStore()
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>!
    
    @Observable
    private(set) var trackerRecords: [TrackerRecord] = []
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistantContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.id, ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
        getTrackerRecords()
    }
    
    private func getTrackerRecords() {
        trackerRecords = {
            guard
                let object = self.fetchedResultsController.fetchedObjects,
                let trackerRecord = try? object.map({ try self.updateTrackerRecord($0)})
            else {
                return []
            }
            return trackerRecord
        }()
    }
    
    func dayIsDone(id: UUID, date: Date) -> Bool {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
            return false
        }
        let trackerContain = fetchedObjects.filter { $0.id == id && $0.date == date }
        return !trackerContain.isEmpty
    }
    
    
    func countDay(id: UUID) -> Int {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
            return 0
        }
        let filteredObjects = fetchedObjects.filter { $0.id == id }
        return filteredObjects.count
    }
    
    func changeRecord(_ record: TrackerRecord) throws {
        guard let object = self.fetchedResultsController.fetchedObjects else { return }
        for trackerRecord in object {
            if trackerRecord.id == record.id &&
                trackerRecord.date == record.date {
                context.delete(trackerRecord)
                try context.save()
                return
            }
        }
        let trackerRecordCD = TrackerRecordCoreData(context: context)
        updateTrackerRecordCoreData(trackerRecordCD, trackerRecord: record)
        try context.save()
    }
    
    func deleteTrackerRecord(_ id: UUID) throws {
        guard let object = self.fetchedResultsController.fetchedObjects else { return }
        for trackerRecord in object {
            if trackerRecord.id == id {
                context.delete(trackerRecord)
            }
            try context.save()
        }
    }
    
    func deleteTrackerRecords(_ arrayID: [UUID]) throws {
        guard let object = self.fetchedResultsController.fetchedObjects else { return }
        for id in arrayID {
            for trackerRecord in object where trackerRecord.id == id {
                context.delete(trackerRecord)
            }
            try context.save()
        }
    }
    
    private func updateTrackerRecordCoreData(_ trackerRecordCoreData: TrackerRecordCoreData, trackerRecord: TrackerRecord) {
        trackerRecordCoreData.id = trackerRecord.id
        trackerRecordCoreData.date = trackerRecord.date
    }
    
    private func updateTrackerRecord(_ trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let id = trackerRecordCoreData.id else {
            throw TrackerRecordError.decodingErrorInvalidId
        }
        guard let date = trackerRecordCoreData.date else {
            throw TrackerRecordError.decodingErrorInvalidDate
        }
        return TrackerRecord(id: id, date: date)
    }
}

//MARK: - Extension TrackerRecordDelegate
extension TrackerRecordStore:NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        getTrackerRecords()
    }
    
}
