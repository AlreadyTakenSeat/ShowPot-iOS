//
//  LoginViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/8/25.
//

import Foundation

import RxCompose
import RxSwift
import RxCocoa

final class LoginViewModel: Composer {
    enum Action {
        case kakaoLoginButtonTapped
        case googleLoginButtonTapped
        case appleLoginButtonTapped
    }
    
    struct State {
        
    }
    
    @ComposableState
    var state = State()
    var action = PublishRelay<Action>()
    var disposeBag = DisposeBag()
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        return .none
    }
}
