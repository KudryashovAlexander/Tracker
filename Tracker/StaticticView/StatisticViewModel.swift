//
//  StatisticViewModel.swift
//  Tracker
//
//  Created by Александр Кудряшов on 24.09.2023.
//

/*
  Для статистики пока только подсчет кол-ва выполненных трекерв без подсчета "Лучший период", "Идеальные дни", "Среднее значение"
 */


import Foundation

class StatisticViewModel {
    
    private(set) var statisticsVM = [StatisticSubViewModel]()
    private let trackerRecordStore = TrackerRecordStore.shared
    
    private var trackerRecord = [TrackerRecord]() {
        didSet {
            getBestPeriod()
            getBestDays()
            getTrackerCompleted()
            getAverage()
            updateStatistic()
        }
    }
    
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
        bind()
        trackerRecord = trackerRecordStore.trackerRecords
        
        getBestPeriod()
        getBestDays()
        getTrackerCompleted()
        getAverage()
        updateStatistic()
    }
    
    private func getBestPeriod(){
        //TODO: метод расчета лучшего периода
        bestPeriod = 10
    }
    
    private func getBestDays(){
        //TODO: метод расчета идельных дней
        bestDays = 3
    }
    
    private func getTrackerCompleted() {
        trackersCompleted = trackerRecord.count
    }
    
    private func getAverage(){
        //TODO: метод расчета среднего значения
        average = 2
    }
    
    private func bind() {
        trackerRecordStore.$trackerRecords.bind { [weak self] newTrackerRecord in
            self?.trackerRecord = newTrackerRecord
        }
    }
    
    private func updateStatistic() {
        if bestPeriod < 1 ||
           bestPeriod < 1 ||
           trackersCompleted < 1 ||
           bestPeriod < 1 {
            statisticIsEmpty = true
        } else {
            statisticIsEmpty = false
        }
    }
}
