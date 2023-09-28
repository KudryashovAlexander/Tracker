//
//  TrackerCategoryViewModel.swift
//  Tracker
//
//  Created by Александр Кудряшов on 21.09.2023.
//

import Foundation

struct TrackerCategoryViewModel {
    @Observable private(set) var name: String
    @Observable private(set) var trackers: [TrackerViewModel]

}
