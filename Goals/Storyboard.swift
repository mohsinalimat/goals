//
//  Storyboard.swift
//  MyGoalsApp
//
//  Created by Guilherme Souza on 08/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case MyGoals
    case AddGoal
    case GoalOverview
    case Payments
    case AddPayment

    func instantiate<VC: UIViewController>(_: VC.Type) -> VC {
        guard let viewController = UIStoryboard(name: self.rawValue, bundle: nil).instantiateInitialViewController() as? VC else {
            fatalError("Could not instantiate \(String(describing: VC.self)) in \(self.rawValue). Make sure the view is set as initial view controller.")
        }
        return viewController
    }
}
