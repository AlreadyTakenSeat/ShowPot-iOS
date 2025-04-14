//
//  LoginUseCase+LiveValue.swift
//  ShowPot
//
//  Created by 김도형 on 4/9/25.
//

import Foundation

import Dependencies

extension LoginUseCase: DependencyKey {
    static let liveValue: LoginUseCase = {
        @Dependency(\.socialLoginRepository.googleLogin)
        var googleLogin
        @Dependency(\.socialLoginRepository.kakaoLogin)
        var kakaoLogin
        @Dependency(\.socialLoginRepository.appleLogin)
        var appleLogin
        @Dependency(\.socialLoginRepository.appleToken)
        var appleToken
        @Dependency(\.usersRepository.login)
        var login
        @Dependency(\.firebaseRepository.fetchFCMToken)
        var fetchFCMToken
        
        return LoginUseCase(
            googleLogin: googleLogin,
            kakaoLogin: kakaoLogin,
            appleLogin: appleLogin,
            appleToken: appleToken,
            login: login,
            fetchFCMToken: fetchFCMToken
        )
    }()
}
