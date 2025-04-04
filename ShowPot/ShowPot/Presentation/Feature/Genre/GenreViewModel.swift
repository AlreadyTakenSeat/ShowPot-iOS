//
//  GenreViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/3/25.
//

import Foundation

import RxCompose
import RxSwift
import RxCocoa

final class GenreViewModel: Composer {
    enum Action {
        case collectionViewItemSelected(Int)
    }
    
    struct State {
        var genres: [GenreEntity] = GenreResponse.mockList.map { $0.toEntity() }
        @PresentState
        var showSubscribeButton: Bool = false
    }
    
    var disposeBag = DisposeBag()
    
    @ComposableState
    var state = State()
    var action = PublishRelay<Action>()
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case let .collectionViewItemSelected(item):
            state.genres[item].isSubscribed?.toggle()
            let showSubscribeButton = !state.genres.filter { genre in
                return genre.isSubscribed ?? false
            }.isEmpty
            state.showSubscribeButton = showSubscribeButton
            return .none
        }
    }
}
