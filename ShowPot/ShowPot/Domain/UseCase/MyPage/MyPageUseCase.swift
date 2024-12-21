//
//  MyPageUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/14/24.
//

import RxSwift
import RxCocoa

protocol MyPageUseCase {
    
    var menuData: BehaviorRelay<[MypageMenuData]> { get }
    var userProfileData: PublishRelay<UserProfileData> { get }
    
    func requestMenuData()
    func requestUserProfileData()
}
