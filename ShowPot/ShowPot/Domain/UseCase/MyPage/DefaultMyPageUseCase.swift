//
//  DefaultMyPageUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/14/24.
//

import Foundation
import RxSwift
import RxRelay

final class DefaultMyPageUseCase: MyPageUseCase {

    private let userAPI = SPUserAPI()
    private let disposeBag = DisposeBag()
    
    var menuData: RxRelay.BehaviorRelay<[MypageMenuData]> = BehaviorRelay<[MypageMenuData]>(value: [])
    var userProfileData = RxRelay.PublishRelay<UserProfileData>()
    
    func requestMenuData() {
        menuData.accept([
            .init(type: .artist, badgeCount: nil),
            .init(type: .genre, badgeCount: nil)
        ])
    }
    
    func requestUserProfileData() {
        userAPI.profileInfo()
            .subscribe { data in
                self.userProfileData.accept(data)
            }
            .disposed(by: disposeBag)
    }
}
