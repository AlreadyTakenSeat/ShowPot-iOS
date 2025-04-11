//
//  ArtistViewModel.swift
//  ShowPot
//
//  Created by 김도형 on 4/4/25.
//

import Foundation

import RxCompose
import RxSwift
import RxCocoa

final class ArtistViewModel: Composer {
    enum Action {
        case collectionViewItemSelected(Int)
    }
    
    struct State {
        var artists: [ArtistEntity] = ArtistEntity.mockList
        var selectedArtists = Set<ArtistEntity>()
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
            let artist = state.artists[item]
            if state.selectedArtists.contains(artist) {
                state.selectedArtists.remove(artist)
            } else {
                state.selectedArtists.insert(artist)
            }
            state.showSubscribeButton = !state.selectedArtists.isEmpty
            return .none
        }
    }
}
