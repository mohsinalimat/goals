//
//  FloatingButton.swift
//  Goals
//
//  Created by Guilherme Souza on 26/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

final class FloatingButton: UIButton {

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 56, height: 56)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = frame.size.height / 2
        layer.shadowRadius = 4
        layer.shadowColor = Color.shadow.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shouldRasterize = true
        layer.masksToBounds = false
    }
}
