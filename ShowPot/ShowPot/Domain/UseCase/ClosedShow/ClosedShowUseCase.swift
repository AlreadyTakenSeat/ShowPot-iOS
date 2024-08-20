//
//  ClosedShowUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/17/24.
//

import RxSwift
import RxCocoa

protocol ClosedShowUseCase {
    
    var closedShowList: BehaviorRelay<[ShowSummary]> { get }
    
    func requestClosedShowData()
}
