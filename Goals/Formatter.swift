//
//  Formatter.swift
//  Goals
//
//  Created by Guilherme Souza on 28/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation

struct Formatter {
    private static let numberFormatter = NumberFormatter()
    private static let dateFormatter = DateFormatter()

    static func currency(from value: Double) -> String? {
        numberFormatter.numberStyle = .currency
        return numberFormatter.string(from: value as NSNumber)
    }

    static func string(from date: Date) -> String? {
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }

}
