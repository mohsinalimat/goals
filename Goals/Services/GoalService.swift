//
//  GoalService.swift
//  Goals
//
//  Created by Guilherme Souza on 26/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift

protocol GoalCreatable {
    func create(with title: String, amount: Double) -> Observable<Goal>
}

protocol GoalLoadable {
    func all() -> Observable<[Goal]>
    func load(uid: String) -> Observable<Goal>
}

struct GoalService {
    private let repository: AbstractRespository<Goal>

    init(repository: AbstractRespository<Goal> = Repository<Goal>()) {
        self.repository = repository
    }
}

extension GoalService: GoalCreatable {
    func create(with title: String, amount: Double) -> Observable<Goal> {
        let goal = Goal(
            uid: UUID().uuidString,
            title: title,
            amount: amount,
            payments: []
        )

        return repository.save(goal)
            .map { _ in goal }
    }
}

extension GoalService: GoalLoadable {
    func all() -> Observable<[Goal]> {
        return repository.queryAll()
    }

    func load(uid: String) -> Observable<Goal> {
        return repository.query(by: uid)
    }
}
