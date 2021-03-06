//
//  KeyboardObserver.swift
//  Goals
//
//  Created by Guilherme Souza on 26/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

protocol KeyboardObservable: class {
    func keyboardWillShow(with rect: CGRect)
    func keyboardWillHide(with rect: CGRect)
}

final class KeyboardObserver {
    private weak var delegate: KeyboardObservable!

    init(delegate: KeyboardObservable) {
        self.delegate = delegate
    }

    func start() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide, object: nil
        )
    }

    func stop() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            delegate.keyboardWillShow(with: keyboardSize)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            delegate.keyboardWillHide(with: keyboardSize)
        }
    }
}
