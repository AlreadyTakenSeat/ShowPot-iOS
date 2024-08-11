//
//  MyShowAlarmUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/11/24.
//
import Foundation
import RxSwift
import RxCocoa

final class MyShowAlarmUseCase: MyShowUseCase {
    var ticketingAlarm: RxRelay.PublishRelay<[TicketingAlarmCellModel]> = PublishRelay<[TicketingAlarmCellModel]>()
    var showList: RxRelay.BehaviorRelay<[PerformanceInfoCollectionViewCellModel]> = BehaviorRelay<[PerformanceInfoCollectionViewCellModel]>(value: [])
    
    func fetchShowList() { // FIXME: - #6 내 공연정보 API 요청
        showList.accept([
            .init(showID: "1", performanceImageURL: URL(string: "https://img.newspim.com/news/2023/09/21/2309210928580280.jpg"), performanceTitle: "에스파단독고연", performanceTime: Date(timeIntervalSinceNow: 24 * 60 * 60), performanceLocation: "KBS 아레나홀"),
            .init(showID: "2", performanceImageURL: URL(string: "https://image.bugsm.co.kr/essential/images/500/39/3978.jpg"), performanceTitle: "샘스미스단독공연", performanceTime: Date(timeIntervalSinceNow: 24 * 60), performanceLocation: "KBS 아레나홀"),
            .init(showID: "3", performanceImageURL: URL(string: "https://img.newspim.com/news/2023/03/06/2303060940437270.jpg"), performanceTitle: "안젤리나졸리단독고연", performanceTime: Date(timeIntervalSinceNow: 24 * 60 * 60 * 60), performanceLocation: "KBS 아레나홀"),
            .init(showID: "4", performanceImageURL: URL(string: "https://www.gugakpeople.com/data/gugakpeople_com/mainimages/202407/2024071636209869.jpg"), performanceTitle: "브루노마스단독고연", performanceTime: Date(timeIntervalSinceNow: 24), performanceLocation: "KBS 아레나홀"),
            .init(showID: "5", performanceImageURL: URL(string: "https://img.newspim.com/news/2023/06/05/2306051642145540.jpg"), performanceTitle: "워시단독고연", performanceTime: Date(timeIntervalSinceNow: 24 * 60 * 60), performanceLocation: "KBS 아레나홀")
        ])
    }
    
    func updateTicketingAlarm(model: [TicketingAlarmCellModel], showID: String) { // FIXME: - #6 내 공연 티켓팅정보 업데이트 API 요청
        LogHelper.debug("티켓팅 알림 업데이트 정보: \(model.filter { $0.isEnabled && $0.isChecked })\n업데이트할 공연아이디: \(showID)")
    }
    
    func deleteShowAlarm(indexPath: IndexPath) {
        var currentShowList = showList.value
        LogHelper.debug("알림 해제한 공연정보: \(currentShowList[indexPath.row])")
        let deleteShowID = currentShowList[indexPath.row].showID
        currentShowList.removeAll(where: { $0.showID == deleteShowID })
        showList.accept(currentShowList)
    }
    
    func requestTicketingAlarm() { // FIXME: - #6 내 공연 티켓팅정보 API 요청
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        let reserveDate = calendar.date(byAdding: .hour, value: 24, to: currentDate) ?? Date() // TODO: - 추후 기준이 될 일반예매시간으로 대체
        
        ticketingAlarm.accept([
            .init(isChecked: true, isEnabled: checkEnabled(since: reserveDate, minimumHour: 24), ticketingAlertText: "티켓팅 24시간 전"),
            .init(isChecked: true, isEnabled: checkEnabled(since: reserveDate, minimumHour: 6), ticketingAlertText: "티켓팅 6시간 전"),
            .init(isChecked: false, isEnabled: checkEnabled(since: reserveDate, minimumHour: 1), ticketingAlertText: "티켓팅 1시간 전")
        ])
    }
}

extension MyShowAlarmUseCase {
    private func checkEnabled(since date: Date, minimumHour: Int) -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.hour], from: currentDate, to: date)
        
        guard let elapsedHours = components.hour else {
            return false
        }
        
        return elapsedHours >= minimumHour
    }
}
