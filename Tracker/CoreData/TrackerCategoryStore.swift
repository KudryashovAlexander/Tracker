//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Александр Кудряшов on 02.09.2023.
//

import UIKit
import CoreData

enum TrackerCategoryError: Error {
    case decodingErrorInvalidName
    case decodingErrorInvalidTrackers
    case convertErrorTrackerCategoryTrackersCoreData
}

struct TrackerCategoryUpdate {
    struct Move: Hashable {
        let oldIndex: IndexPath
        let newIndex: IndexPath
    }
    let insertedIndexes: IndexPath
    let deletedIndexes: IndexPath
    let updateIndexes: IndexPath
    let movedIndexes: Set<Move>
}

protocol TrackerCategoryStoryDelegate: AnyObject {
    func store( _ store: TrackerCategoryStory, didUpdate update: TrackerCategoryUpdate)
}

class TrackerCategoryStory: NSObject {
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    weak var delegate: TrackerCategoryStoryDelegate?
    private var insertedIndexes: IndexPath?
    private var deletedIndexes: IndexPath?
    private var updateIndexes: IndexPath?
    private var movedIndexes: Set<TrackerCategoryUpdate.Move>?
    private var currentTrackerCategory: TrackerCategory?
    
    private var trackerStore = TrackerStore()
    var trackerCategory: [TrackerCategory] {
            guard
                let object = self.fetchedResultsController.fetchedObjects,
                let trackerCategory = try? object.map({ try self.updateTrackerCategory($0)})
            else { return [] }
            return trackerCategory
    }
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistantContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.name, ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    func updateTrackerCategoryCoreData(_ trackerCategoryCoreData: TrackerCategoryCoreData,
                                       with trackerCategory: TrackerCategory) throws {
        trackerCategoryCoreData.name = trackerCategory.name
        let trackerSet = NSSet()
        
        trackerCategoryCoreData.trackers = trackerSet
        
    }
    
    func updateTrackerCategory( _ trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let name = trackerCategoryCoreData.name else {
            throw TrackerCategoryError.decodingErrorInvalidName
        }
        var trackers = [Tracker]()
        if let trackersCoreData = trackerCategoryCoreData.trackers {
            for tracker in trackersCoreData {
                try trackers.append(trackerStore.updateTracker(tracker as! TrackerCoreData))
            }
        }
        
        return TrackerCategory(name: name, trackers: trackers)
    }
    
    func addCategory(_ newCategory: TrackerCategory) throws {
        let newCategoryCoreData = TrackerCategoryCoreData(context:context)
        try updateTrackerCategoryCoreData(newCategoryCoreData, with: newCategory)
        try context.save()
    }
    
    func deleteCategory(_ category: TrackerCategory) throws {
        guard let object = self.fetchedResultsController.fetchedObjects else { return }
        for trackerCategory in object {
            if trackerCategory.name == category.name {
                if let trackers = trackerCategory.trackers {
                    let trackerArray = trackers.compactMap { $0 as? TrackerCoreData}
                    for tracker in trackerArray {
                        do {
                            try trackerStore.deleteTrackerCoreData(tracker)
                        } catch {
                            print("Не удалось удалить трекер \(tracker.name ?? "")")
                        }
                    }
                }
                context.delete(trackerCategory)
                try context.save()
            }
        }
        
    }
    
    func addTracker(at newTracker: Tracker, category: TrackerCategory) throws {
        currentTrackerCategory = category
        guard let object = self.fetchedResultsController.fetchedObjects else { return }
        for trackerCategory in object {

            if trackerCategory.name == category.name {
                if let trackersSet = trackerCategory.trackers {
                    let newTrackerCoreData = try trackerStore.addTracker(at: newTracker)
                    let mutableTrackersSet = NSMutableSet(set: trackersSet)
                    mutableTrackersSet.add(newTrackerCoreData)
                    
                    trackerCategory.trackers = mutableTrackersSet
                    try context.save()
                    return
                }
            }
        }
        try addCategory(category)
        try addTracker(at: newTracker, category: category)
    }
    
    func deleteTracker(at tracker: Tracker, category: TrackerCategory) throws {
        guard let object = self.fetchedResultsController.fetchedObjects else { return }
        
        for trackerCategory in object {
            guard let trackers = trackerCategory.trackers else {
               throw TrackerCategoryError.decodingErrorInvalidTrackers
            }
            let trackerArray = trackers.compactMap { $0 as? TrackerCoreData }
            for trackerCoreData in trackerArray {
                if trackerCoreData.id == tracker.id {
                    try trackerStore.deleteTracker(at: tracker)
                }
            }
        }
    }
    
    
}

//MARK: - Extension NSFetchedResultsControllerDelegate
extension TrackerCategoryStory: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexPath()
        deletedIndexes = IndexPath()
        updateIndexes = IndexPath()
        movedIndexes = Set<TrackerCategoryUpdate.Move>()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(
            self,
            didUpdate: TrackerCategoryUpdate(
                insertedIndexes: insertedIndexes!,
                deletedIndexes: deletedIndexes!,
                updateIndexes: updateIndexes!,
                movedIndexes: movedIndexes!
            ))
        
        insertedIndexes = nil
        deletedIndexes = nil
        updateIndexes = nil
        movedIndexes = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else {fatalError()}
            insertedIndexes = indexPath
        case .delete:
            guard let indexPath = indexPath else {fatalError(debugDescription)}
            deletedIndexes = indexPath
        case .update:
            guard let indexPath = indexPath else {fatalError()}
            updateIndexes = indexPath
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {fatalError()}
            movedIndexes?.insert(.init(oldIndex: oldIndexPath, newIndex: newIndexPath))
        @unknown default:
            fatalError()
        }
    }
    
}
