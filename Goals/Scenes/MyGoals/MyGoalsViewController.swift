//
//  MyGoalsViewController.swift
//  Goals
//
//  Created by Guilherme Souza on 26/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import IGListKit
import RxSwift

final class GoalDisplayable: ListDiffable {
    let uid: String
    let title: String
    let totalAmount: Double
    let remainingAmount: Double

    let goal: Goal

    init(goal: Goal) {
        self.goal = goal
        
        uid = goal.uid
        title = goal.title
        totalAmount = goal.amount
        remainingAmount = goal.remaining
    }

    func diffIdentifier() -> NSObjectProtocol {
        return uid as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? GoalDisplayable else { return false }
        return object.uid == uid &&
            object.title == title &&
            object.totalAmount == totalAmount &&
            object.remainingAmount == remainingAmount
    }
}

final class MyGoalsViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var addButton: FloatingButton!

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        return control
    }()

    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    private var items: [GoalDisplayable] = []

    private let viewModel: MyGoalsViewModelType = MyGoalsViewModel()
    private let disposeBag = DisposeBag()
    private lazy var transition = CircularTransition()

    static func instantiate() -> MyGoalsViewController {
        return Storyboard.MyGoals.instantiate(MyGoalsViewController.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My Goals"
        addButton.backgroundColor = Color.primaryGreen
        addButton.tintColor = .white

        let buttonMargin: CGFloat = 64
        collectionView.contentInset.bottom = buttonMargin + addButton.frame.height
        collectionView.refreshControl = refreshControl
        adapter.collectionView = collectionView
        adapter.dataSource = self

        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.input.viewDidAppear()
    }

    private func bindViewModel() {
        viewModel.output.goals
            .drive(onNext: { [weak self] goals in
                self?.items = goals
                self?.adapter.performUpdates(animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.output.isLoading
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }

    @IBAction private func addButtonTapped(_ sender: UIButton) {
        let addGoalViewController = AddGoalViewController.instantiate()
        addGoalViewController.modalPresentationStyle = .custom
        addGoalViewController.transitioningDelegate = self
        present(addGoalViewController, animated: true)
    }

    @objc private func pullToRefresh(_ refreshControl: UIRefreshControl) {
        viewModel.input.pullToRefresh()
    }
}

extension MyGoalsViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return items
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = MyGoalsSectionController()
        sectionController.delegate = self
        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension MyGoalsViewController: MyGoalsSectionControllerDelegate {
    func didSelectGoal(_ goal: Goal) {

        let vc1 = UINavigationController(rootViewController: GoalOverviewViewController.instantiate(with: goal))
        vc1.tabBarItem = UITabBarItem(title: "Overview", image: Image.overviewIcon, selectedImage: Image.overviewSelectedIcon)
        let vc2 = UINavigationController(rootViewController: PaymentsViewController.instantiate(with: goal))
        vc2.tabBarItem = UITabBarItem(title: "Payments", image: Image.creditCardIcon, tag: 1)

        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([vc1, vc2], animated: false)

        present(tabBarController, animated: true)
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

