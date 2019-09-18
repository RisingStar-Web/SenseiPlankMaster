//
//  Data.swift
//  SenseiPlankMaster
//
//  Created by Роман Кабиров on 13.09.2018.
//  Copyright © 2018 Logical Mind. All rights reserved.
//

import Foundation

class WorkoutData {
    static let days = [
        20, 20, 30,
        30, 40, 20,
        45, 45, 60,
        60, 60, 90,
        30, 90, 90,
        120, 120, 150,
        30, 150, 150,
        180, 180, 210,
        210, 30, 240,
        240, 270, 300
    ]
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
