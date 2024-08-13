//
//  MyAlarmUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/13/24.
//

import RxSwift
import RxCocoa

protocol MyAlarmUseCase {
    var upcomingShowList: BehaviorRelay<[MyShowData]> { get }
    var showArtistList: BehaviorRelay<[ArtistShowInfo]> { get }
    var menuList: BehaviorRelay<[MyMenuData]> { get }
    
    func requestMenuData()
    func requestUpcomingShow()
}
