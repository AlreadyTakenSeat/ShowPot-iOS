//
//  ArtistUseCase+LiveValue.swift
//  ShowPot
//
//  Created by 김도형 on 4/13/25.
//

import Foundation

import Dependencies

extension ArtistUseCase: DependencyKey {
    static let liveValue: ArtistUseCase = {
        @Dependency(\.artistsRepository.subscribe)
        var artistsSubscribe
        @Dependency(\.artistsRepository.unsubscriptionList)
        var artistsUnsubscriptionList
        
        return ArtistUseCase(
            subscribe: artistsSubscribe,
            unsubscriptionList: artistsUnsubscriptionList
        )
    }()
}
