//
//  AddPaymentViewModel.swift
//  Goals
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright (c) 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol AddPaymentViewModelInput {
    func confirmTapped()
    func amountChanged(_ value: String?)
}

protocol AddPaymentViewModelOutput {
    var paymentCreated: Driver<Void> { get }
}

protocol AddPaymentViewModelType {
    var input: AddPaymentViewModelInput { get }
    var output: AddPaymentViewModelOutput { get }
}

final class AddPaymentViewModel: AddPaymentViewModelType, AddPaymentViewModelInput, AddPaymentViewModelOutput {

    let paymentCreated: SharedSequence<DriverSharingStrategy, Void>

    init(goal: Goal, paymentService: PaymentCreatable = PaymentService()) {

        let amount = amountProperty.asDriverOnErrorJustComplete().skipNil().map(Double.init).skipNil()

        paymentCreated = confirmProperty.withLatestFrom(amount)
            .flatMap { amount in paymentService.create(with: amount, on: goal) }
            .asDriverOnErrorJustComplete()
            .mapToVoid()
    }

    private let confirmProperty = PublishSubject<Void>()
    func confirmTapped() {
        confirmProperty.onNext(())
    }

    private let amountProperty = PublishSubject<String?>()
    func amountChanged(_ value: String?) {
        amountProperty.onNext(value)
    }

    var input: AddPaymentViewModelInput { return self }
    var output: AddPaymentViewModelOutput { return self }
}
