//
//  DefaultMyPageUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DefaultMyPageUseCase: MyPageUseCase {
    
    var menuData: RxRelay.BehaviorRelay<[MypageMenuData]> = BehaviorRelay<[MypageMenuData]>(value: [])
    
    func requestMenuData() {
        menuData.accept([
            .init(type: .artist, badgeCount: nil),
            .init(type: .genre, badgeCount: nil)
        ])
    }
}
