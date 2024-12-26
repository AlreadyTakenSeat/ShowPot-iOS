//
//  DefaultMyAlarmListUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 9/24/24.
//

import Foundation

import RxSwift
import RxCocoa

// TODO: #129 MyAlarmList -> MyAlarm 네이밍 변경
final class DefaultMyAlarmListUseCase: MyAlarmListUseCase {

    private let apiService: SPShowAPI
    private let disposeBag = DisposeBag()

    var myAlarmModel: RxRelay.BehaviorRelay<[MyAlarmInfo]> = BehaviorRelay<[MyAlarmInfo]>(value: [])

    init(apiService: SPShowAPI = SPShowAPI()) {
        self.apiService = apiService
        requestMyAlarmModel()
    }

    func requestMyAlarmModel() {
        myAlarmModel.accept([
            .init(thumbnailImageURL: URL(string: "https://ticketimage.interpark.com/Play/image/large/24/24006288_p.gif"), mainAlarm: "티켓팅이 1시간 남았어요!", subAlarm: "1시간 후, 0000 티켓팅이 오픈됩니다.🥰", timeLeft: "1분전"),
            .init(thumbnailImageURL: URL(string: "https://ticketimage.interpark.com/Play/image/large/24/24006714_p.gif"), mainAlarm: "티켓팅이 6시간 남았어요!", subAlarm: "6시간 후, 0000 예매가 오픈됩니다.🥰", timeLeft: "5시간 전"),
            .init(thumbnailImageURL: URL(string: "https://ticketimage.interpark.com/Play/image/large/24/24011642_p.gif"), mainAlarm: "구독장르의 공연이 오픈 되었어요!", subAlarm: "EDM 장르의 공연이 업데이트 되었어요.", timeLeft: "10분전"),
            .init(thumbnailImageURL: URL(string: "https://ticketimage.interpark.com/Play/image/large/24/24007623_p.gif"), mainAlarm: "구독한 아티스트 공연이 오픈 되었어요!", subAlarm: "힙합 장르의 공연이 업데이트 되었어요.", timeLeft: "2시간 전"),
            .init(thumbnailImageURL: URL(string: "https://media.bunjang.co.kr/product/262127257_1_1714651082_w360.jpg"), mainAlarm: "티켓팅이 24시간 남았어요!", subAlarm: "High Flying Birds 의 공연이 업데이트 되었어요.", timeLeft: "8분전"),
        ])
    }
}
