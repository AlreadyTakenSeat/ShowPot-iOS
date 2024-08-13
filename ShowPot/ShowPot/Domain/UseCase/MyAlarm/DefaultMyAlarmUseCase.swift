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
    var showArtistList: RxRelay.BehaviorRelay<[ArtistShowInfo]> = BehaviorRelay<[ArtistShowInfo]>(value: [])
    var menuList: RxRelay.BehaviorRelay<[MyMenuData]> = BehaviorRelay<[MyMenuData]>(value: [])
    var upcomingShowList: RxRelay.BehaviorRelay<[MyShowData]> = BehaviorRelay<[MyShowData]>(value: [])

    func requestUpcomingShow() {
        
        let backgroundTicketImageList: [UIImage] = [.orangeTicket, .greenTicket, .blueTicket, .yellowTicket]
        
        showArtistList.accept([
            .init(artistName: "Dua lipa", remainDay: "공연 티켓팅까지, \(calculateDDay(to: Array(86400 * 1...86400 * 2).shuffled().map { Date(timeIntervalSinceNow: TimeInterval($0)) }[0]))"),
            .init(artistName: "Michael Jackson", remainDay: "공연 티켓팅까지, \(calculateDDay(to: Array(86400 * 1...86400 * 20).shuffled().map { Date(timeIntervalSinceNow: TimeInterval($0)) }[0]))"),
            .init(artistName: "Anjelinanana", remainDay: "공연 티켓팅까지, \(calculateDDay(to: Array(86400 * 1...86400 * 1).shuffled().map { Date(timeIntervalSinceNow: TimeInterval($0)) }[0]))"),
            .init(artistName: "Tarzan Azars", remainDay: "공연 티켓팅까지, \(calculateDDay(to: Array(86400 * 1...86400 * 20).shuffled().map { Date(timeIntervalSinceNow: TimeInterval($0)) }[0]))"),
            .init(artistName: "JustLikeThantKR", remainDay: "공연 티켓팅까지, \(calculateDDay(to: Array(86400 * 1...86400 * 20).shuffled().map { Date(timeIntervalSinceNow: TimeInterval($0)) }[0]))"),
            .init(artistName: "ShowPot Team", remainDay: "공연 티켓팅까지, \(calculateDDay(to: Array(86400 * 1...86400 * 20).shuffled().map { Date(timeIntervalSinceNow: TimeInterval($0)) }[0]))")
        ])
        upcomingShowList.accept([ // FIXME: - API연동 이후 %연산자로 backgroundImage적용 필요
            .init(backgroundImage: .orangeTicket, showThubnailURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg"), showName: "OPN(Oneohtrix Point Never)", showLocation: "KBS 아레나홀", showStartTime: Date(timeIntervalSinceNow: 24), showEndTime: Date(timeIntervalSinceNow: 24*60), ticketingOpenTime: Date(timeIntervalSinceNow: 24*2)),
            .init(backgroundImage: .greenTicket, showThubnailURL: URL(string: "https://cdn.pixabay.com/photo/2016/03/05/22/17/food-1239231_1280.jpg"), showName: "OPN(Oneohtrix Point Never)", showLocation: "NEXTERS 아레나홀", showStartTime: Date(timeIntervalSinceNow: 24), showEndTime: Date(timeIntervalSinceNow: 24*60+10), ticketingOpenTime: Date(timeIntervalSinceNow: 24*2)),
            .init(backgroundImage: .blueTicket, showThubnailURL: URL(string: "https://cdn.pixabay.com/photo/2015/10/10/13/41/polar-bear-980781_1280.jpg"), showName: "OPN(Oneohtrix Point Never)", showLocation: "YAPP 레빗홀", showStartTime: Date(timeIntervalSinceNow: 24), showEndTime: Date(timeIntervalSinceNow: 24*60*9), ticketingOpenTime: Date(timeIntervalSinceNow: 24*2)),
            .init(backgroundImage: .yellowTicket, showThubnailURL: URL(string: "https://cdn.pixabay.com/photo/2014/04/05/11/41/butterfly-316740_1280.jpg"), showName: "OPN(Oneohtrix Point Never)", showLocation: "올림픽스타디움", showStartTime: Date(timeIntervalSinceNow: 24), showEndTime: Date(timeIntervalSinceNow: 24*60*4), ticketingOpenTime: Date(timeIntervalSinceNow: 24*2)),
            .init(backgroundImage: .orangeTicket, showThubnailURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg"), showName: "OPN(Oneohtrix Point Never)", showLocation: "하남 스타필드", showStartTime: Date(timeIntervalSinceNow: 24), showEndTime: Date(timeIntervalSinceNow: 24*60*3), ticketingOpenTime: Date(timeIntervalSinceNow: 24*2)),
            .init(backgroundImage: .greenTicket, showThubnailURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg"), showName: "OPN(Oneohtrix Point Never)", showLocation: "오리지널 나쵸", showStartTime: Date(timeIntervalSinceNow: 24), showEndTime: Date(timeIntervalSinceNow: 24*60*2), ticketingOpenTime: Date(timeIntervalSinceNow: 24*2))
            
        ])
    }
    
    func requestMenuData() {
        
        let menus = ["알림 설정한 공연", "구독한 아티스트", "구독한 장르"]
        menuList.accept(menus.compactMap { .init(type: MyAlarmMenuType.menuType(title: $0), badgeCount: Array(1...100).shuffled()[0]) })
    }
    
    func calculateDDay(from currentDate: Date = Date(), to targetDate: Date) -> String {
        let calendar = Calendar.current
        
        // 두 날짜 사이의 일(day) 차이를 계산
        let components = calendar.dateComponents([.day], from: currentDate, to: targetDate)
        
        guard let daysDifference = components.day else {
            return "Error calculating D-Day"
        }
        
        if daysDifference > 0 {
            return "D-\(daysDifference)"
        } else if daysDifference == 0 {
            return "D-Day"
        } else {
            fatalError("This Show already open ticketing") // 목표일이 현재 날짜보다 과거에 있는 경우
        }
    }
}

