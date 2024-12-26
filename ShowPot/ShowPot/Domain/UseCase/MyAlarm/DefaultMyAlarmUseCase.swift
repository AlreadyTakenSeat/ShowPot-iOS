//
//  DefaultMyAlarmUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/13/24.
//

import UIKit

import RxSwift
import RxCocoa

// TODO: #129 MyAlarm -> UpcomingShow 네이밍 변경
final class DefaultMyAlarmUseCase: MyAlarmUseCase {
    
    private let apiService: SPShowAPI
    private let disposeBag = DisposeBag()
    
    init(apiService: SPShowAPI = SPShowAPI()) {
        self.apiService = apiService
    }
    
    var menuList: RxRelay.BehaviorRelay<[MyShowMenuData]> = BehaviorRelay<[MyShowMenuData]>(value: [])
    var upcomingShowList: RxRelay.BehaviorRelay<[ShowData]> = BehaviorRelay<[ShowData]>(value: [])
    
    func requestUpcomingShow() {
        
        let backgroundTicketImageList: [UIImage] = [.orangeTicket, .greenTicket, .blueTicket, .yellowTicket]
        let currentDate = Date()
        
        apiService.alertList()
            .subscribe(with: self) { owner, response in
                owner.upcomingShowList.accept(response.data.enumerated().map {
                    ShowData(
                        id: $1.id,
                        showTitle: $1.title,
                        remainDay: currentDate.daysUntil(DateFormatterFactory.dateWithISO.date(from: $1.cursorValue) ?? Date()),
                        backgroundImage: backgroundTicketImageList[$0 % backgroundTicketImageList.count],
                        thubnailURL: URL(string: $1.imageURL),
                        location: $1.location,
                        startTime: DateFormatterFactory.dateWithHypen.date(from: $1.startAt),
                        endTime: DateFormatterFactory.dateWithHypen.date(from: $1.endAt),
                        ticketingOpenTime: DateFormatterFactory.dateWithISO.date(from: $1.cursorValue)
                    )
                })
            }
            .disposed(by: disposeBag)
    }
    
    func requestMenuData() {
        // TODO: #192 MVP 이후 badeCount 구현 / 종료된 공연 표출
        menuList.accept([
            .init(type: .alarmPerformance, badgeCount: nil),
            .init(type: .interestShow, badgeCount: nil)
            /* .init(type: .closedShow, badgeCount: nil) */
        ])
    }
}
