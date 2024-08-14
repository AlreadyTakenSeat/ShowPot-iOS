//
//  DefaultMyAlarmUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/13/24.
//

import UIKit

import RxSwift
import RxCocoa

final class DefaultMyAlarmUseCase: MyAlarmUseCase {

    var menuList: RxRelay.BehaviorRelay<[MyShowMenuData]> = BehaviorRelay<[MyShowMenuData]>(value: [])
    var upcomingShowList: RxRelay.BehaviorRelay<[ShowData]> = BehaviorRelay<[ShowData]>(value: [])

    func requestUpcomingShow() {
        
        let backgroundTicketImageList: [UIImage] = [.orangeTicket, .greenTicket, .blueTicket, .yellowTicket]
        let currentDate = Date()
        
        upcomingShowList.accept([ // FIXME: - API연동 이후 %연산자로 backgroundImage적용 필요
            .init(artistName: "Dua lipa", remainDay: currentDate.daysUntil(Array(86400 * 1...86400 * 2).shuffled().map { Date(timeIntervalSinceNow: TimeInterval($0)) }[0]), backgroundImage: .orangeTicket, thubnailURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg"), name: "OPN(Oneohtrix Point Never)", location: "KBS 아레나홀", startTime: Date(timeIntervalSinceNow: 24), endTime: Date(timeIntervalSinceNow: 24*60), ticketingOpenTime: Date(timeIntervalSinceNow: 24*2)),
            .init(artistName: "Michael Jackson", remainDay: currentDate.daysUntil(Array(86400 * 1...86400 * 20).shuffled().map { Date(timeIntervalSinceNow: TimeInterval($0)) }[0]), backgroundImage: .greenTicket, thubnailURL: URL(string: "https://cdn.pixabay.com/photo/2016/03/05/22/17/food-1239231_1280.jpg"), name: "Coldplay - A Head Full of Dreams Tour", location: "NEXTERS 아레나홀", startTime: Date(timeIntervalSinceNow: 24), endTime: Date(timeIntervalSinceNow: 24*60+10), ticketingOpenTime: Date(timeIntervalSinceNow: 24*2)),
            .init(artistName: "Anjelinanana", remainDay: currentDate.daysUntil(Array(86400 * 1...86400 * 1).shuffled().map { Date(timeIntervalSinceNow: TimeInterval($0)) }[0]), backgroundImage: .blueTicket, thubnailURL: URL(string: "https://cdn.pixabay.com/photo/2015/10/10/13/41/polar-bear-980781_1280.jpg"), name: "BTS - Love Yourself Tour", location: "YAPP 레빗홀", startTime: Date(timeIntervalSinceNow: 24), endTime: Date(timeIntervalSinceNow: 24*60*9), ticketingOpenTime: Date(timeIntervalSinceNow: 24*2)),
            .init(artistName: "Tarzan Azars", remainDay: currentDate.daysUntil(Array(86400 * 1...86400 * 20).shuffled().map { Date(timeIntervalSinceNow: TimeInterval($0)) }[0]), backgroundImage: .yellowTicket, thubnailURL: URL(string: "https://cdn.pixabay.com/photo/2014/04/05/11/41/butterfly-316740_1280.jpg"), name: "Ed Sheeran - Divide Tour", location: "올림픽스타디움", startTime: Date(timeIntervalSinceNow: 24), endTime: Date(timeIntervalSinceNow: 24*60*4), ticketingOpenTime: Date(timeIntervalSinceNow: 24*2)),
            .init(artistName: "JustLikeThantKR", remainDay: currentDate.daysUntil(Array(86400 * 1...86400 * 20).shuffled().map { Date(timeIntervalSinceNow: TimeInterval($0)) }[0]), backgroundImage: .orangeTicket, thubnailURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg"), name: "Maroon 5 - Red Pill Blues Tour", location: "하남 스타필드", startTime: Date(timeIntervalSinceNow: 24), endTime: Date(timeIntervalSinceNow: 24*60*3), ticketingOpenTime: Date(timeIntervalSinceNow: 24*2)),
            .init(artistName: "ShowPot Team", remainDay: currentDate.daysUntil(Array(86400 * 1...86400 * 20).shuffled().map { Date(timeIntervalSinceNow: TimeInterval($0)) }[0]), backgroundImage: .greenTicket, thubnailURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg"), name: "The Weeknd - Starboy: Legend of the Fall Tour", location: "오리지널 나쵸", startTime: Date(timeIntervalSinceNow: 24), endTime: Date(timeIntervalSinceNow: 24*60*2), ticketingOpenTime: Date(timeIntervalSinceNow: 24*2))
            
        ])
    }
    
    func requestMenuData() {
        // TODO: - 추후 메뉴에 대한 badgeCount 적용 필요
        menuList.accept([
            .init(type: .alarmPerformance, badgeCount: Array(1...10).shuffled()[0]),
            .init(type: .artist, badgeCount: Array(1...10).shuffled()[0]),
            .init(type: .genre, badgeCount: Array(1...10).shuffled()[0])
        ])
    }
}
