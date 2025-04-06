//
//  MyPageViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/6/25.
//

import Foundation

import RxCompose
import RxSwift
import RxCocoa

final class MyPageViewModel: Composer {
    enum Action {
        case loginButtonTapped
        case settingButtonTapped
    }
    
    struct State {
        var isLoggedIn: Bool = true
        var nickname: String = "춤추는 고래"
        var subscribedArtistsCount: Int = 0
        var subscribedGenresCount: Int = 0
    }
    
    @ComposableState
    var state = State()
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        return .none
    }
}
