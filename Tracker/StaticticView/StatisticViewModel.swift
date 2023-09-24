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
    
    @Observable
    private(set) var statisticIsEmpty: Bool = false
    
    private lazy var bestPeriodVM = StatisticSubViewModel(statisticNumber: getBestPeriod(),
                                                     statisticName: String().statisticBestRecord)
    
    private lazy var bestDaysVM = StatisticSubViewModel(statisticNumber: getBestDays(),
                                                       statisticName: String().statisticPerfextDays)
    
    private lazy var trackerCompletedVM = StatisticSubViewModel(statisticNumber: getTrackerCompleted(),
                                                       statisticName: String().statisticTrackerCompleted)
    
    private lazy var averageVM = StatisticSubViewModel(statisticNumber: getAverage(),
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
    
    private func getTrackerCompleted() -> Int {
        return 10
    }
    
    private func getAverage() -> Int {
        return 10
    }
    
    
}
