//
//  PaymentCell.swift
//  Goals
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

final class PaymentCell: UICollectionViewCell {
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!

    func setup(with item: PaymentDisplayable) {
        dateLabel.text = Formatter.string(from: item.date)
        amountLabel.text = Formatter.currency(from: item.amount)
    }
}
