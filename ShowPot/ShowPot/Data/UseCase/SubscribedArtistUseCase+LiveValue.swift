//
//  SubscribedArtistUseCase+LiveValue.swift
//  ShowPot
//
//  Created by 김도형 on 4/19/25.
//

import Foundation

import Dependencies

extension SubscribedArtistUseCase: DependencyKey {
    static let liveValue: SubscribedArtistUseCase = {
        @Dependency(\.artistsRepository.unsubscribe)
        var artistsUnsubscribe
        @Dependency(\.artistsRepository.subscriptionList)
        var artistsSubscriptionList
        
        return SubscribedArtistUseCase(
            unsubscribe: artistsUnsubscribe,
            subscriptionList: artistsSubscriptionList
        )
    }()
}
