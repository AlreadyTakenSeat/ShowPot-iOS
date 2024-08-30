//
//  InterestShowUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/16/24.
//

import RxSwift
import RxCocoa

protocol InterestShowUseCase {
    
    var interestShowList: BehaviorRelay<[ShowSummary]> { get }
    
    func deleteInterestShow(_ show: ShowSummary)
    func requestInterestShowData()
}
