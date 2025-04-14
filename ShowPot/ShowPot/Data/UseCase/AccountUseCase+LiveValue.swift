//
//  AccountUseCase+LiveValue.swift
//  ShowPot
//
//  Created by 김도형 on 4/13/25.
//

import Foundation

import Dependencies

extension AccountUseCase: DependencyKey {
    static let liveValue: AccountUseCase = {
        @Dependency(\.usersRepository.withdrawal)
        var withdrawal
        @Dependency(\.usersRepository.logout)
        var logout
        @Dependency(\.usersRepository.profile)
        var profile
        @Dependency(\.socialLoginRepository.appleRevoke)
        var appleRevoke
        
        return AccountUseCase(
            withdrawal: withdrawal,
            logout: logout,
            profile: profile,
            appleRevoke: appleRevoke
        )
    }()
}
