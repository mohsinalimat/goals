//
//  Double.swift
//  Goals
//
//  Created by Guilherme Souza on 27/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation

extension Double {

    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

}
