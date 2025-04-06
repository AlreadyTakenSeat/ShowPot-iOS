//
//  ShowListViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/6/25.
//

import Foundation

import RxCompose
import RxSwift
import RxCocoa

final class ShowListViewModel: Composer {
    enum Action {
        
    }
    
    struct State {
        var notifications: [ShowEntity] = [
            ShowEntity(id: "1", title: "티켓팅이 1시간 남았어요!", startAt: "1시간 후, 0,000 티켓팅이 오픈됩니다.😍", endAt: "", location: "1분전", imageURL: "https://example.com/show1.jpg"),
            ShowEntity(id: "2", title: "티켓팅이 6시간 남았어요!", startAt: "6시간 후, 0,000 예매가 오픈됩니다.😍", endAt: "", location: "5시간 전", imageURL: "https://example.com/show2.jpg"),
            ShowEntity(id: "3", title: "구독장르 공연이 오픈 되었어요!", startAt: "EDM 장르의 공연이 업데이트 되었습니다.", endAt: "", location: "6시간 전", imageURL: "https://example.com/show3.jpg")
        ]
    }
    
    @ComposableState
    var state = State()
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        return .none
    }
}
