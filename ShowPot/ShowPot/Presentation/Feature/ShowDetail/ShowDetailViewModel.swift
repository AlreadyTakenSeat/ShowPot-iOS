//
//  ShowDetailViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/4/25.
//

import Foundation

import RxCompose
import RxSwift
import RxCocoa

final class ShowDetailViewModel: Composer {
    enum Action {
        case favoriteButtonTapped
        case alarmButtonTapped
        case alarmSelectionViewModel(AlarmSelectionViewModel.Action)
    }
    
    struct State {
        var show: ShowDetailEntity = .mock
        @PresentState
        var isFavorite = false
        @PresentState
        var alarmSelectionViewModel: AlarmSelectionViewModel?
    }
    
    @ComposableState
    var state = State()
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .favoriteButtonTapped:
            state.isFavorite.toggle()
            return .none
        case .alarmButtonTapped:
            let viewModel = AlarmSelectionViewModel(
                ticketingTimes: state.show.ticketingTimes
            )
            state.alarmSelectionViewModel = viewModel
            return .run(viewModel.action.map {
                .alarmSelectionViewModel($0)
            })
        case let .alarmSelectionViewModel(.delegate(.bottomButtonTapped(alertTimes))):
            state.alarmSelectionViewModel = nil
            print(alertTimes)
            return .none
        case .alarmSelectionViewModel: return .none
        }
    }
}
