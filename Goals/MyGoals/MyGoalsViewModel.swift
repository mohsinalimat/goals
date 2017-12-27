//
//  MyGoalsViewModel.swift
//  Goals
//
//  Created by Guilherme Souza on 26/12/17.
//  Copyright (c) 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol MyGoalsViewModelInput {}

protocol MyGoalsViewModelOutput {}

protocol MyGoalsViewModelType {
    var input: MyGoalsViewModelInput { get }
    var output: MyGoalsViewModelOutput { get }
}

final class MyGoalsViewModel: MyGoalsViewModelType, MyGoalsViewModelInput, MyGoalsViewModelOutput {
    
    var input: MyGoalsViewModelInput { return self }
    var output: MyGoalsViewModelOutput { return self }
}
