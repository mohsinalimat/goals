//
//  MyGoalsViewModel.swift
//  Goals
//
//  Created by Guilherme Souza on 26/12/17.
//  Copyright (c) 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol MyGoalsViewModelInput {
    func viewDidAppear()
    func pullToRefresh()
}

protocol MyGoalsViewModelOutput {
    var goals: Driver<[GoalDisplayable]> { get }
    var isLoading: Driver<Bool> { get }
}

protocol MyGoalsViewModelType {
    var input: MyGoalsViewModelInput { get }
    var output: MyGoalsViewModelOutput { get }
}

final class MyGoalsViewModel: MyGoalsViewModelType, MyGoalsViewModelInput, MyGoalsViewModelOutput {
    let goals: SharedSequence<DriverSharingStrategy, [GoalDisplayable]>
    let isLoading: SharedSequence<DriverSharingStrategy, Bool>

    init(goalService: GoalLoadable = GoalService()) {
        let activityTracker = ActivityTracker()
        isLoading = activityTracker.asDriver()

        goals = Observable.merge(viewDidAppearProperty, pullToRefreshProperty)
            .flatMap { _ in
                goalService.all()
                    .trackActivity(activityTracker)
            }
            .map(arrange)
            .map { $0.map(GoalDisplayable.init) }
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

    var input: MyGoalsViewModelInput { return self }
    var output: MyGoalsViewModelOutput { return self }
}

private func arrange(_ goals: [Goal]) -> [Goal] {
    var arrangedGoals: [Goal] = []
    arrangedGoals.reserveCapacity(goals.count)

    let notCompletedGoals = goals.filter { !$0.isCompleted }
    let completedGoals = goals.filter { $0.isCompleted }

    return notCompletedGoals + completedGoals
}
