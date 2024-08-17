//
//  EndShowUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/17/24.
//

import RxSwift
import RxCocoa

protocol EndShowUseCase {
    
    var showList: BehaviorRelay<[ShowSummary]> { get }
    
    func requestShowData()
}
