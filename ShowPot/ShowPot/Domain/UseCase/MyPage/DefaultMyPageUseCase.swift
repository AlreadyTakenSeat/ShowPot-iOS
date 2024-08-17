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
    var recentShowData: RxRelay.BehaviorRelay<[ShowSummary]> = BehaviorRelay<[ShowSummary]>(value: [])
    
    func requestShowData() {
        recentShowData.accept([
            .init(id: "1", thumbnailURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg"), title: "Nothing But Thieves Nothing But Thieves", location: "서울 하남 스타필드", time: Date(timeIntervalSinceNow: 100*12345)),
            .init(id: "2", thumbnailURL: URL(string: "https://cdn.pixabay.com/photo/2015/08/22/15/39/giraffes-901009_1280.jpg"), title: "ShowPot 로고스홀", location: "롯데월드 윈터홀", time: Date(timeIntervalSinceNow: 100*121345)),
            .init(id: "3", thumbnailURL: URL(string: "https://cdn.pixabay.com/photo/2024/03/24/14/47/hippopotamus-8653246_1280.png"), title: "Michael Jackson Dancing In the moon", location: "올림픽공원 시네마인터시티", time: Date(timeIntervalSinceNow: 1030*12345))
        ])
    }
    
    func requestMenuData() {
        menuData.accept([
            .init(type: .artist, badgeCount: 10),
            .init(type: .genre, badgeCount: 15)
        ])
    }
}
