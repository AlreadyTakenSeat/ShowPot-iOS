//
//  MyAlarmUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/13/24.
//

import RxSwift
import RxCocoa

protocol MyAlarmUseCase {
    var upcomingShowList: BehaviorRelay<[ShowData]> { get }
    var menuList: BehaviorRelay<[MyShowMenuData]> { get }
    
    func requestMenuData()
    func requestUpcomingShow()
}
