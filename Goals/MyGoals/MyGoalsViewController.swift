//
//  MyGoalsViewController.swift
//  Goals
//
//  Created by Guilherme Souza on 26/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

final class MyGoalsViewController: UIViewController {

    @IBOutlet weak var addButton: FloatingButton!

    private let viewModel: MyGoalsViewModelType = MyGoalsViewModel()
    private let transition = CircularTransition()

    static func instantiate() -> MyGoalsViewController {
        return Storyboard.MyGoals.instantiate(MyGoalsViewController.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.backgroundColor = Color.primaryGreen
        addButton.tintColor = .white
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        let addGoalViewController = AddGoalViewController.instantiate()
        addGoalViewController.modalPresentationStyle = .custom
        addGoalViewController.transitioningDelegate = self
        present(addGoalViewController, animated: true)
    }
}

extension MyGoalsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = addButton.center
        transition.circleColor = addButton.backgroundColor!
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = addButton.center
        return transition
    }
}
