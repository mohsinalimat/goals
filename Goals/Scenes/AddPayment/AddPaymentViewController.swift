//
//  AddPaymentViewController.swift
//  Goals
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift

final class AddPaymentViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet private weak var confirmButton: FloatingButton!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var confirmButtonBottomConstraint: NSLayoutConstraint!

    private var viewModel: AddPaymentViewModelType!
    private let disposeBag = DisposeBag()
    private lazy var keyboardObserver = KeyboardObserver(delegate: self)

    static func instantiate(with goal: Goal) -> AddPaymentViewController {
        let controller = Storyboard.AddPayment.instantiate(AddPaymentViewController.self)
        controller.viewModel = AddPaymentViewModel(goal: goal)
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        amountTextField.addTarget(self, action: #selector(amountTextFieldChanged(_:)), for: .editingChanged)

        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardObserver.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardObserver.stop()
    }

    private func bindViewModel() {
        viewModel.output.paymentCreated
            .drive(onNext: clearFields)
            .disposed(by: disposeBag)
    }

    private func clearFields() {
        amountTextField.text = nil
    }

    // MARK: Actions and Handlers
    @IBAction private func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction private func confirmButtonTapped(_ sender: UIButton) {
        viewModel.input.confirmTapped()
    }

    @objc private func amountTextFieldChanged(_ textField: UITextField) {
        viewModel.input.amountChanged(textField.text)
    }

    // MARK: View's setup
    private func setupView() {
        view.backgroundColor = Color.primaryGreen
        view.tintColor = .white
        amountTextField.textColor = .white
        confirmButton.backgroundColor = .white
        confirmButton.tintColor = .black
    }
}

// MARK: - Keyboard Observable
extension AddPaymentViewController: KeyboardObservable {
    func keyboardWillShow(with rect: CGRect) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.confirmButtonBottomConstraint.constant = 32 + rect.height
            self.view.layoutIfNeeded()
        }
    }

    func keyboardWillHide(with rect: CGRect) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.confirmButtonBottomConstraint.constant = 32
            self.view.layoutIfNeeded()
        }
    }
}
