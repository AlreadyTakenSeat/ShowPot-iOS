//
//  MyShowViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/5/25.
//

import Foundation

import RxCompose
import RxSwift
import RxCocoa

final class MyShowViewModel: Composer {
    enum Action {
        
    }
    
    struct State {
        var shows: [ShowAlarmEntity] = [
            .mock,
            .mock.with(title: "Dua Lipa", ticketingAt: "2025-3-4 10:04"),
            .mock .with(title: "Coldplay", ticketingAt: "2025-3-4 10:04")
        ]
        var alertsCount = 0
        var interestCount = 0
        var ticketingCount = 0
    }
    
    @ComposableState
    var state = State()
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        return .none
    }
}
