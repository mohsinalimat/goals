//
//  RMGoal.swift
//  Goals
//
//  Created by Guilherme Souza on 26/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RealmSwift

final class RMGoal: Object {
    @objc dynamic var uid: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var amount: Double = 0.0
    let payments = List<RMPayment>()

    override class func primaryKey() -> String? {
        return "uid"
    }
}

extension RMGoal: DomainConvertibleType {
    func asDomain() -> Goal {
        return Goal(
            uid: uid,
            title: title,
            amount: amount,
            payments: payments.mapToDomain()
        )
    }
}

extension Goal: RealmRepresentable {
    func asRealm() -> RMGoal {
        return RMGoal.build { object in
            object.uid = uid
            object.title = title
            object.amount = amount
            object.payments.append(objectsIn: payments.map { $0.asRealm() })
        }
    }
}
