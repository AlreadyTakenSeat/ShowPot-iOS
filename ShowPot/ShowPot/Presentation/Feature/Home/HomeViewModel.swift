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
    enum Action {
        case searchTextFieldEditingDidEndOnExit(String)
    }
    
    struct State {
        var genres: [GenreEntity] = GenreResponse.mockList.map { $0.toEntity() }
        var artists: [ArtistEntity] = ArtistResponse.mockList.map { $0.toEntity() }
        var upcomingShows: [ShowOpenEntity] = [ShowOpenResponse.mock.toEntity()]
        var recommendedShows: [ShowEntity] = ShowEntity.mockList
    }
    
    var disposeBag = DisposeBag()
    
    @ComposableState
    var state = State()
    var action = PublishRelay<Action>()
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case let .searchTextFieldEditingDidEndOnExit(text):
            return .none
        }
    }
}
