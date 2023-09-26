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
      Для статистики пока только подсчет кол-ва выполненных трекерв без подсчета "Лучший период", "Идеальные дни", "Среднее значение"
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
        
        getTrackerCompleted()
    }
    
    private func getBestPeriod(){
        //TODO: метод расчета лучшего периода
        bestPeriod = 10
    }
    
    private func getBestDays(){
        //TODO: метод расчета идельных дней
        bestPeriod = 3
    }
    
    private func getTrackerCompleted() {
        trackersCompleted = trackerRecordStore.trackerRecords.count
    }
    
    private func getAverage(){
        //TODO: метод расчета среднего значения
        bestPeriod = 2
    }
    
}
