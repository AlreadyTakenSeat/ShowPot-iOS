//
//  HomeViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/2/25.
//

import Foundation

import RxCompose
import RxSwift
import RxCocoa

final class HomeViewModel: Composer {
    enum Action { }
    
    struct State { }
    
    var disposeBag = DisposeBag()
    
    @ComposableState
    var state = State()
    var action = PublishRelay<Action>()
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        return .none
    }
}
