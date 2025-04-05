//
//  AlarmSelectionViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/5/25.
//

import Foundation

import RxCompose
import RxSwift
import RxCocoa

final class AlarmSelectionViewModel: Composer {
    enum Action {
        case itemSelected(Int)
        case bottomButtonTapped
        case delegate(Delegate)
        
        enum Delegate {
            case bottomButtonTapped([String])
        }
    }
    
    struct State {
        var alarms = AlertTime.allCases
        var selectedTime = Set<AlertTime>()
        let ticketingTimes: [ShowDetailEntity.TicketingTime]
    }
    
    @ComposableState
    var state: State
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()
    
    init(ticketingTimes: [ShowDetailEntity.TicketingTime]) {
        self.state = State(ticketingTimes: ticketingTimes)
    }
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .delegate: return .none
        case let .itemSelected(item):
            let time = state.alarms[item]
            if state.selectedTime.remove(time) == nil {
                state.selectedTime.insert(time)
            }
            return .none
        case .bottomButtonTapped:
            let selectedTime = state.selectedTime
            let alertTimes = state.ticketingTimes.map(\.ticketingAt)
                .flatMap { ticketingAt in
                    selectedTime.compactMap { time in
                        return ticketingAt.toDate(.default)?
                            .addMinutes(minutes: -Double(time.minutes))
                            .toString(.default)
                    }
                }
            return .send(.delegate(.bottomButtonTapped(alertTimes)))
        }
    }
}
