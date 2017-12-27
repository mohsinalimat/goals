//
//  GoalOverviewViewController.swift
//  Goals
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift

final class GoalOverviewViewController: UIViewController {

    @IBOutlet private weak var progressView: ProgressView!
    @IBOutlet private weak var totalNeededLabel: UILabel!
    @IBOutlet private weak var totalPaidLabel: UILabel!
    @IBOutlet private weak var remainingLabel: UILabel!

    private lazy var currencyFormatter: NumberFormatter = makeNumberFormatter()
    private func makeNumberFormatter() -> NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        return nf
    }

    private var viewModel: GoalOverviewViewModelType!
    private let disposeBag = DisposeBag()

    static func instantiate(with goal: Goal) -> GoalOverviewViewController {
        let controller = Storyboard.GoalOverview.instantiate(GoalOverviewViewController.self)
        controller.viewModel = GoalOverviewViewModel(goal: goal)
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.closeIcon, style: .done, target: self, action: #selector(dismissTapped(_:)))
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.input.viewDidAppear()
    }

    private func bindViewModel() {
        viewModel.output.goal
            .drive(onNext: { [weak self] goal in
                self?.navigationItem.title = goal.title
                self?.totalNeededLabel.text = self?.currencyFormatter.string(from: goal.amount as NSNumber)
                self?.totalPaidLabel.text = self?.currencyFormatter.string(from: goal.totalPaid as NSNumber)
                self?.remainingLabel.text = self?.currencyFormatter.string(from: goal.remaining as NSNumber)

                let ratio = goal.totalPaid / goal.amount
                self?.progressView.animate(to: CGFloat(ratio))
            })
            .disposed(by: disposeBag)
    }

    @objc private func dismissTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

}
