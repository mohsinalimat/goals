//
//  GoalOverviewViewController.swift
//  Goals
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

final class GoalOverviewViewController: UIViewController {

    private var goal: Goal!

    static func instantiate(with goal: Goal) -> GoalOverviewViewController {
        let controller = Storyboard.GoalOverview.instantiate(GoalOverviewViewController.self)
        controller.goal = goal
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = goal.title
    }

}
