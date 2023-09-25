//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Александр Кудряшов on 25.09.2023.
//

import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "412c50d1-cb1d-40ef-a0a2-06f913a57635") else { return }
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event:String, params: [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params) { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        }
    }
    
}
