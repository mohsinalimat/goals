//
//  PaymentService.swift
//  Goals
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift

protocol PaymentLoadable {
    func all(from uid: String) -> Observable<[Payment]>
}

protocol PaymentCreatable {
    func create(with amount: Double, on goal: Goal) -> Observable<Payment>
}

protocol PaymentDeletable {
    func delete(_ payment: Payment) -> Observable<Void>
}

struct PaymentService {
    private let paymentRepository: AbstractRespository<Payment>
    private let goalRepository: AbstractRespository<Goal>

    init(
        paymentRepository: AbstractRespository<Payment> = Repository<Payment>(),
        goalRepository: AbstractRespository<Goal> = Repository<Goal>()
        ) {
        self.paymentRepository = paymentRepository
        self.goalRepository = goalRepository
    }
}

extension PaymentService: PaymentLoadable {
    func all(from uid: String) -> Observable<[Payment]> {
        let predicate = NSPredicate(format: "goalUID = %@", uid)
        let sort = NSSortDescriptor(key: "date", ascending: false)

        return paymentRepository.query(
            with: predicate,
            sortDescriptors: [sort]
        )
    }
}

extension PaymentService: PaymentCreatable {
    func create(with amount: Double, on goal: Goal) -> Observable<Payment> {
        let payment = Payment(
            uid: UUID().uuidString,
            date: Date(),
            amount: amount,
            goalUID: goal.uid
        )

        var goal = goal
        goal.payments.append(payment)

        return goalRepository.save(goal)
            .map { _ in payment }
    }
}

extension PaymentService: PaymentDeletable {
    func delete(_ payment: Payment) -> Observable<Void> {
        return paymentRepository.delete(by: payment.uid)
    }
}
