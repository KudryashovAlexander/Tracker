//
//  String_ext.swift
//  Tracker
//
//  Created by Александр Кудряшов on 28.08.2023.
//

import Foundation

extension String {
    func firstCharOnly() -> String {
        return prefix(1).uppercased() + self.dropFirst()
    }
}
