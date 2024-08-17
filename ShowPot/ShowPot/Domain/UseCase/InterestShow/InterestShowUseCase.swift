//
//  InterestShowUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/16/24.
//

import RxSwift
import RxCocoa

protocol InterestShowUseCase {
    
    var showList: BehaviorRelay<[ShowSummary]> { get }
    
    func deleteShow(show: ShowSummary)
    func requestShowData()
}
