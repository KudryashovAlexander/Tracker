//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Александр Кудряшов on 02.09.2023.
//

import Foundation

enum TrackerRecordError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidDate
}

class TrackerRecordStore {
    
    
    func updateTrackerRecordCoreData(_ trackerREcordCoreData: TrackerRecordCoreData, with trackerRecord: TrackerRecord) {
        trackerREcordCoreData.id = trackerRecord.id
        trackerREcordCoreData.date = trackerRecord.date
    }
    
    
    func updateTrackerrecord(_ trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let id = trackerRecordCoreData.id else {
            throw TrackerRecordError.decodingErrorInvalidId
        }
        guard let date = trackerRecordCoreData.date else {
            throw TrackerRecordError.decodingErrorInvalidDate
        }
        
        return TrackerRecord(id: id,
                             date: date)
    }
    
}
