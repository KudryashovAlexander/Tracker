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

protocol TrackerCategoryStoryDelegate: AnyObject {
    func store(didUpdate trackerCategory: [TrackerCategory])
}

class TrackerCategoryStore: NSObject {
    
    static let shared = TrackerCategoryStore()
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    weak var delegate: TrackerCategoryStoryDelegate?
    private var currentTrackerCategoryName: String?
    
    private var trackerStore = TrackerStore()
    
    @Observable
    private(set) var trackerCategory: [TrackerCategory] = []
    
    var trackerCategoryViewModel: [CategoryViewModel] {
        guard
            let object = self.fetchedResultsController.fetchedObjects,
            let trackerCategory = try? object.map({ trackerCategoryCoreData in
                CategoryViewModel(categoryName: trackerCategoryCoreData.name!,
                                  categoryIsSelected: false)
            })
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
        getTrackerCategory()
    }
    
    private func getTrackerCategory() {
        trackerCategory = { guard
            let object = self.fetchedResultsController.fetchedObjects,
            let trackerCategory = try? object.map({ try self.updateTrackerCategory($0)})
            else { return [] }
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
    
    func addTracker(at newTracker: Tracker, categoryName: String) throws {
        currentTrackerCategoryName = categoryName
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
        if oldCategoryName != newCategoryName {
            try deleteTracker(at: oldTracker, categoryName: oldCategoryName)
            try addTracker(at: newTracker, categoryName: newCategoryName)
        }
        trackerStore.changeTracker(oldTracker: oldTracker, newTracker: newTracker)
    }
    
    func deleteTracker(at tracker: Tracker, categoryName: String) throws {
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
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        getTrackerCategory()
    }
    
}
