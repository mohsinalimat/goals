//
//  Payment.swift
//  Goals
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation

struct Payment {
    let uid: String
    let date: Date
    let amount: Double

    let goalUID: String
}

extension Payment: Equatable {
    static func ==(lhs: Payment, rhs: Payment) -> Bool {
        return lhs.uid == rhs.uid &&
            lhs.date == rhs.date &&
            lhs.amount == rhs.amount &&
            lhs.goalUID == rhs.goalUID
    }
}
