//
//  MyPageUseCase+LiveValue.swift
//  ShowPot
//
//  Created by 김도형 on 4/13/25.
//

import Foundation

import Dependencies

extension MyPageUseCase: DependencyKey {
    static let liveValue: MyPageUseCase = {
        @Dependency(\.usersRepository.profile)
        var profile
        @Dependency(\.artistsRepository.subscriptionCount)
        var artistsSubscriptionCount
        @Dependency(\.genresRepository.subscriptionCount)
        var genresSubscriptionCount
        
        return MyPageUseCase(
            profile: profile,
            artistsSubscriptionCount: artistsSubscriptionCount,
            genresSubscriptionCount: genresSubscriptionCount
        )
    }()
}
