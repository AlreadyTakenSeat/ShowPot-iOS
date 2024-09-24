//
//  MyAlarmListUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 9/24/24.
//

import RxSwift
import RxCocoa

protocol MyAlarmListUseCase {
    var myAlarmModel: BehaviorRelay<[MyAlarmInfo]> { get }
    func requestMyAlarmModel()
}
