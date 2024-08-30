//
//  MyShowAlarmUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/11/24.
//
import Foundation
import RxSwift
import RxRelay

final class MyShowAlarmUseCase: MyShowUseCase {
    
    private let showAPI = SPShowAPI()
    private let disposeBag = DisposeBag()
    
    var updateTicketingAlarmResult = PublishRelay<Bool>()
    var ticketingAlarm = PublishRelay<[TicketingAlarmCellModel]>()
    var showList = BehaviorRelay<[PerformanceInfoCollectionViewCellModel]>(value: [])
    
    func fetchShowList() {
        
        showAPI.alertList()
            .map { response in
                response.data.map { showData in
                    PerformanceInfoCollectionViewCellModel(
                        showID: showData.id,
                        performanceImageURL: URL(string: showData.imageURL),
                        performanceTitle: showData.title,
                        performanceTime: showData.startAt.date("yyyy.MM.dd"),
                        performanceLocation: showData.location
                    )
                }
            }.bind(to: showList)
            .disposed(by: disposeBag)
    }
    
    func updateTicketingAlarm(model: [TicketingAlarmCellModel], showID: String) {
        LogHelper.debug("티켓팅 알림 업데이트 정보: \(model.filter { $0.isEnabled && $0.isChecked })\n업데이트할 공연아이디: \(showID)")
        showAPI.updateAlert(showId: showID)
            .subscribe {
                self.updateTicketingAlarmResult.accept(true)
            } onError: { error in
                self.updateTicketingAlarmResult.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    func deleteShowAlarm(indexPath: IndexPath) {
        LogHelper.debug("알림 해제한 공연정보: \(showList.value[indexPath.row])")
        let deleteShowID = showList.value[indexPath.row].showID
        showAPI.updateAlert(showId: deleteShowID)
            .subscribe {
                self.updateTicketingAlarmResult.accept(true)
            } onError: { error in
                self.updateTicketingAlarmResult.accept(false)
            } onCompleted: {
                self.fetchShowList()
            }
            .disposed(by: disposeBag)
    }
    
    func requestTicketingAlarm(showId: String) {
        showAPI.reservationInfo(showId: showId)
            .map { response in
                let availability = response.alertReservationAvailability
                let status = response.alertReservationStatus
                
                return [
                    TicketingAlarmCellModel(
                        isChecked: status.before24,
                        isEnabled: false, // FIXME: - 데모데이이후 false -> availability.canReserve24로 수정
                        ticketingAlertText: "티켓팅 24시간 전"
                    ),
                    TicketingAlarmCellModel(
                        isChecked: status.before6,
                        isEnabled: false, // FIXME: - 데모데이이후 false -> availability.canReserve6로 수정
                        ticketingAlertText: "티켓팅 6시간 전"
                    ),
                    TicketingAlarmCellModel(
                        isChecked: status.before1,
                        isEnabled: availability.canReserve1,
                        ticketingAlertText: "티켓팅 1시간 전"
                    )
                ]
            }
            .bind(to: ticketingAlarm)
            .disposed(by: disposeBag)
    }
}
