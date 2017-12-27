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

    private static let dateFormatter: DateFormatter = makeDateFormatter()
    private static let currencyFormatter: NumberFormatter = makeNumberFormatter()

    private static func makeDateFormatter() -> DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }

    private static func makeNumberFormatter() -> NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        return nf
    }

    func setup(with item: PaymentDisplayable) {
        dateLabel.text = PaymentCell.dateFormatter.string(from: item.date)
        amountLabel.text = PaymentCell.currencyFormatter.string(from: item.amount as NSNumber)
    }
}
