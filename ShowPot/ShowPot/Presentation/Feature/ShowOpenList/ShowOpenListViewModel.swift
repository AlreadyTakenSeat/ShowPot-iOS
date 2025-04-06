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

final class ShowOpenListViewModel: Composer {
    enum Action {
        case filterCheckBoxTapped
    }
    
    struct State {
        var showOpens: [ShowOpenEntity] = ShowOpenEntity.mock
        var isNotOpen = false
    }
    
    @ComposableState
    var state = State()
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .filterCheckBoxTapped:
            state.isNotOpen.toggle()
            /// 임시
            if state.isNotOpen {
                state.showOpens = ShowOpenEntity.mock.filter { !$0.isOpen }
            } else {
                state.showOpens = ShowOpenEntity.mock.filter { $0.isOpen }
            }
            return .none
        }
    }
}
