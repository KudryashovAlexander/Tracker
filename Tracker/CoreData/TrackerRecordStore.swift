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

struct TrackerRecordUpdate {
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
}

protocol TrackerRecordDelegate: AnyObject {
    func store( _ store: TrackerRecordStore, didUpdate update: TrackerRecordUpdate)
}

class TrackerRecordStore: NSObject {
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>!
    weak var delegate: TrackerRecordDelegate?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    
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
    }
    
    func newRecord(_ record: TrackerRecord) throws {
        guard var object = self.fetchedResultsController.fetchedObjects else { return }
        for trackerRecord in object {
            if trackerRecord.id == record.id &&
                trackerRecord.date == record.date {
                context.delete(trackerRecord)
            } else {
                let newTrackerRecord = updateTrackerRecordCoreData(record)
            }
        }
        try context.save()
    }
    
    func updateTrackerRecordCoreData(_ trackerRecord: TrackerRecord) -> TrackerRecordCoreData {
        let trackerRecordCoreData = TrackerRecordCoreData()
        trackerRecordCoreData.id = trackerRecord.id
        trackerRecordCoreData.date = trackerRecord.date
        return trackerRecordCoreData
    }
    
    func updateTrackerrecord(_ trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
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
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(self,
                        didUpdate: TrackerRecordUpdate(insertedIndexes: insertedIndexes!,
                                                       deletedIndexes: deletedIndexes!))
        insertedIndexes = nil
        deletedIndexes = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else {fatalError()}
            insertedIndexes?.insert(indexPath.item)
        case .delete:
            guard let indexPath = indexPath else {fatalError(debugDescription)}
            deletedIndexes?.insert(indexPath.item)
        default:
            fatalError()
        }
    }
}
