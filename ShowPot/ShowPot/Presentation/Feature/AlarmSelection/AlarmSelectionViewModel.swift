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
        case viewDidLoad
        case delegate(Delegate)
        
        enum Delegate {
            case bottomButtonTapped(Set<String>)
        }
    }
    
    struct State {
        var show: ShowDetailEntity
        var times: [ReservationTimeEntity]
        var ticketingTimes = Set<String>()
    }
    
    @ComposableState
    var state: State
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()
    
    init(state: State) {
        self.state = state
    }
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .delegate: return .none
        case let .itemSelected(item):
            state.times[item].isReserved.toggle()
            let ticketingAt = state.show.ticketingTimes.first(
                where: { $0.ticketingAPIType == .normal }
            )?.ticketingAt
            let date = ticketingAt?.toDate(.default)?.addMinutes(
                minutes: -Double(state.times[item].beforeMinutes)
            ).toString(.default)
            guard let date else { return .none }
            if state.times[item].isReserved {
                state.ticketingTimes.insert(date)
            } else {
                state.ticketingTimes.remove(date)
            }
            return .none
        case .bottomButtonTapped:
            return .send(.delegate(.bottomButtonTapped(state.ticketingTimes)))
        case .viewDidLoad:
            let ticketingAt = state.show.ticketingTimes.first(
                where: { $0.ticketingAPIType == .normal }
            )?.ticketingAt
            for (index, time) in state.times.enumerated() {
                let date = ticketingAt?.toDate(.default)?.addMinutes(
                    minutes: -Double(time.beforeMinutes)
                )
                guard let date else { continue }
                state.times[index].canReserve = date > .now
                guard date > .now else { continue }
                guard time.isReserved else { continue }
                state.ticketingTimes.insert(date.toString(.default))
            }
            print(state.ticketingTimes)
            return .none
        }
    }
}
