//
//  PaymentsViewModel.swift
//  Goals
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright (c) 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol PaymentsViewModelInput {
    func viewDidAppear()
    func pullToRefresh()
    func addPaymentTapped()
}

protocol PaymentsViewModelOutput {
    var payments: Driver<[PaymentDisplayable]> { get }
    var isLoading: Driver<Bool> { get }
    var showAddPaymentWithGoal: Driver<Goal> { get }
}

protocol PaymentsViewModelType {
    var input: PaymentsViewModelInput { get }
    var output: PaymentsViewModelOutput { get }
}

final class PaymentsViewModel: PaymentsViewModelType, PaymentsViewModelInput, PaymentsViewModelOutput {

    let payments: SharedSequence<DriverSharingStrategy, [PaymentDisplayable]>
    let isLoading: SharedSequence<DriverSharingStrategy, Bool>
    let showAddPaymentWithGoal: SharedSequence<DriverSharingStrategy, Goal>

    init(goal: Goal, paymentService: PaymentLoadable = PaymentService()) {
        let activityTracker = ActivityTracker()
        isLoading = activityTracker.asDriver()

        showAddPaymentWithGoal = addPaymentTappedProperty.map { _ in goal }
            .asDriverOnErrorJustComplete()
        
        payments = Observable.merge(viewDidAppearProperty, pullToRefreshProperty)
            .flatMap { _ in
                return paymentService.all(from: goal.uid)
                    .trackActivity(activityTracker)
            }
            .map { $0.map(PaymentDisplayable.init) }
            .asDriver(onErrorJustReturn: [])
    }

    private let viewDidAppearProperty = PublishSubject<Void>()
    func viewDidAppear() {
        viewDidAppearProperty.onNext(())
    }

    private let pullToRefreshProperty = PublishSubject<Void>()
    func pullToRefresh() {
        pullToRefreshProperty.onNext(())
    }

    private let addPaymentTappedProperty = PublishSubject<Void>()
    func addPaymentTapped() {
        addPaymentTappedProperty.onNext(())
    }

    var input: PaymentsViewModelInput { return self }
    var output: PaymentsViewModelOutput { return self }
}
