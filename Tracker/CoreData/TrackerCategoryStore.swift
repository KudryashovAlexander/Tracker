//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Александр Кудряшов on 02.09.2023.
//

import CoreData
import UIKit

enum TrackerCategoryError: Error {
    case decodingErrorInvalidName
    case decodingErrorInvalidTrackers
    case convertErrorTrackerCategoryTrackersCoreData
}

class TrackerCategoryStore: NSObject {
    
    static let shared = TrackerCategoryStore()
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    private var trackerStore = TrackerStore.shared
    
    @Observable
    private(set) var trackerCategory: [TrackerCategory] = []
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistantContainer.viewContext
        try! self.init(context: context)
        
        trackerStore.$trackers.bind { [weak self] _ in
            self?.getTrackerCategory()
        }
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
        getTrackerCategory()
    }
    
    private func getTrackerCategory() {
        trackerCategory = { guard
            let object = self.fetchedResultsController.fetchedObjects,
            let trackerCategory = try? object.map({ try self.updateTrackerCategory($0)})
            else {
            return []
        }
            return trackerCategory
        }()
    }
    
    private func updateTrackerCategoryCoreData(_ trackerCategoryCoreData: TrackerCategoryCoreData,
                                       with trackerCategory: TrackerCategory) throws {
        trackerCategoryCoreData.name = trackerCategory.name
        let trackerSet = NSSet()
        trackerCategoryCoreData.trackers = trackerSet
    }
    
    private func updateTrackerCategory( _ trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
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
        var deleteTrackersCoreData = [TrackerCoreData]()
        for trackerCategory in object where trackerCategory.name == category.name {
            if let trackers = trackerCategory.trackers {
                let trackerArray = trackers.compactMap { $0 as? TrackerCoreData}
                deleteTrackersCoreData = trackerArray
                for trackerCoreData in trackerArray {
                    trackerCategory.removeFromTrackers(trackerCoreData)
                }
            }
            context.delete(trackerCategory)
            try context.save()
        }
        //При удалении категории дополнительно удаляем трекеры внутри этой категории из памяти
        try trackerStore.deleteTrackersCoreData(deleteTrackersCoreData)
    }
    

    
    func changeNameCategory(oldName: String, newName: String) throws {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        let predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.name), oldName)
        request.predicate = predicate
        
        do {
            let results = try context.fetch(request)
            
            for trackerCoreData in results {
                if let name = trackerCoreData.name {
                    if name == oldName {
                        trackerCoreData.name = newName
                        try context.save()
                    }
                }
            }
            
        } catch {
            print("Ошибка при редактировании трекера")
        }
        
    }
    
    func changeTracker(oldTracker: Tracker, oldCategoryName: String, newTracker: Tracker, newCategoryName: String) throws {
        
        trackerStore.changeTracker(oldTracker: oldTracker, newTracker: newTracker)

        if oldCategoryName != newCategoryName {
            try! moveTrackerInCategory(at: oldTracker.id, oldCategoryName: oldCategoryName, newCategoryName: newCategoryName)
        }
    }
    
    private func moveTrackerInCategory(at trackerID: UUID, oldCategoryName: String, newCategoryName: String) throws {
        guard let object = self.fetchedResultsController.fetchedObjects else { return }
        
        var moveTrackerCoreData = TrackerCoreData()
        for trackerCategory in object {
            guard let trackers = trackerCategory.trackers else {
               throw TrackerCategoryError.decodingErrorInvalidTrackers
            }
            let trackerArray = trackers.compactMap { $0 as? TrackerCoreData }
            for trackerCoreData in trackerArray where trackerCoreData.id == trackerID {
                moveTrackerCoreData = trackerCoreData
                trackerCategory.removeFromTrackers(trackerCoreData)
                try context.save()
            }
        }
        
        for trackerCategory in object {
            if trackerCategory.name == newCategoryName {
                if let trackersSet = trackerCategory.trackers {
                    let mutableTrackersSet = NSMutableSet(set: trackersSet)
                    mutableTrackersSet.add(moveTrackerCoreData)
                    trackerCategory.trackers = mutableTrackersSet
                    try context.save()
                    return
                }
            }
        }
    }
    
    
    func deleteTracker(at trackerID: UUID) throws {
        guard let object = self.fetchedResultsController.fetchedObjects else { return }
        
        for trackerCategory in object {
            guard let trackers = trackerCategory.trackers else {
               throw TrackerCategoryError.decodingErrorInvalidTrackers
            }
            let trackerArray = trackers.compactMap { $0 as? TrackerCoreData }
            for trackerCoreData in trackerArray where trackerCoreData.id == trackerID {
                trackerCategory.removeFromTrackers(trackerCoreData)
                try context.save()
                try trackerStore.deleteTracker(at: trackerCoreData.id!)
            }
        }
        
    }
    
    func addNewTrackerToCategory(at newTracker: Tracker, categoryName: String) throws {
        guard let object = self.fetchedResultsController.fetchedObjects else { return }
        for trackerCategory in object {

            if trackerCategory.name == categoryName {
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
    }
}

//MARK: - Extension NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        getTrackerCategory()
    }
    
}
