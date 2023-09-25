//
//  StatisticViewModel.swift
//  Tracker
//
//  Created by Александр Кудряшов on 24.09.2023.
//

import Foundation

class StatisticViewModel {
    
    private(set) var statisticsVM = [StatisticSubViewModel]()
    private let trackerRecordStore = TrackerRecordStore.shared
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    /*
     Gjrfpfntkb
     */
    
    @Observable
    private(set) var statisticIsEmpty: Bool = false
    
    private var bestPeriod: Int = 0 {
        didSet {
            bestPeriodVM.newNumber(bestPeriod)
        }
    }
    private var bestDays: Int = 0 {
        didSet {
            bestDaysVM.newNumber(bestDays)
        }
    }
    private var trackersCompleted: Int = 0 {
        didSet {
            trackerCompletedVM.newNumber(trackersCompleted)
        }
    }
    private var average: Int = 0 {
        didSet {
            averageVM.newNumber(average)
        }
    }
    
    private lazy var bestPeriodVM = StatisticSubViewModel(statisticNumber: bestPeriod,
                                                          statisticName: String().statisticBestRecord)
    
    private lazy var bestDaysVM = StatisticSubViewModel(statisticNumber: bestDays,
                                                        statisticName: String().statisticPerfextDays)
    
    private lazy var trackerCompletedVM = StatisticSubViewModel(statisticNumber: trackersCompleted,
                                                                statisticName: String().statisticTrackerCompleted)
    
    private lazy var averageVM = StatisticSubViewModel(statisticNumber: average,
                                                       statisticName: String().statisticAverageValue)
    
    init() {
        statisticsVM.append(bestPeriodVM)
        statisticsVM.append(bestDaysVM)
        statisticsVM.append(trackerCompletedVM)
        statisticsVM.append(averageVM)
    }
    
    private func getBestPeriod() -> Int {
        return 10
    }
    
    private func getBestDays() -> Int {
        return 10
    }
    
    private func getTrackerCompleted() {
        trackersCompleted = trackerRecordStore.trackerRecords.count
    }
    
    private func getAverage() -> Int {
        return 10
    }
    
    private func calculationStatistic() {
        
    }
    
    
}
