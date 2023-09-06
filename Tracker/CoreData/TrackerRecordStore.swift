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

protocol TrackerRecordStoreDelegate: AnyObject {
    func store( _ store: [TrackerRecord])
}

class TrackerRecordStore: NSObject {
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>!
    weak var delegate: TrackerRecordStoreDelegate?
    
    var trackerRecords: [TrackerRecord] {
        do {
            guard
                let object = self.fetchedResultsController.fetchedObjects,
                let trackerRecord = try? object.map({ try self.updateTrackerRecord($0)})
            else {
                return []
            }
            return trackerRecord
        }
    }
    
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
    
    func countDayAndIsDone(id: UUID, date: Date) -> (Int,Bool) {
        var countDay = 0
        var dayIsDone = false
        let trackerIDString = id.uuidString
        
        let requestDayCount = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        let predicateForDay = NSPredicate(format: "%K == %@", (\TrackerRecordCoreData.id)._kvcKeyPathString!, trackerIDString)
        requestDayCount.predicate = predicateForDay
        requestDayCount.resultType = .countResultType
        do {
            let count = try context.count(for:requestDayCount)
            countDay = count
        } catch {
            print("Ошибка в подсчете количества для рекорда")
            countDay = 0
        }
        
        let requestIsDayDone = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let predicateIsDone = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.date), date as CVarArg)
        let sumPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateForDay, predicateIsDone])
        
        requestIsDayDone.predicate = sumPredicate
        
        do {
            let count = try context.count(for:requestIsDayDone)
            if count > 0 {
                dayIsDone = true
            }
        } catch {
            print("Ошибка в подсчете выбран ли день")
        }
        
        return (countDay, dayIsDone)
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
        delegate?.store(trackerRecords)
    }
    
}
