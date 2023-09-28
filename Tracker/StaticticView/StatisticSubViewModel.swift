//
//  StatisticSubViewModel.swift
//  Tracker
//
//  Created by Александр Кудряшов on 24.09.2023.
//

import Foundation

struct StatisticSubViewModel {
    
    @Observable
    private(set) var statisticNumber: Int
    private(set) var statisticName: String
    
    mutating func newNumber(_ newNumber: Int) {
        self.statisticNumber = newNumber
    }
}
