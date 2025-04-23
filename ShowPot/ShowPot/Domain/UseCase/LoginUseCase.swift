//
//  LoginUseCase.swift
//  ShowPot
//
//  Created by 김도형 on 4/9/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct LoginUseCase {
    var googleLogin: () async throws -> SocialLoginEntity
    var kakaoLogin: () async throws -> SocialLoginEntity
    var appleLogin: () async throws -> SocialLoginEntity
    var appleToken: () async throws -> Void
    var login: (LoginEntity) async throws -> Void
    var fetchFCMToken: () async throws -> String
}

extension LoginUseCase: TestDependencyKey {
    static let testValue: LoginUseCase = {
        return LoginUseCase(
            googleLogin: { .mock },
            kakaoLogin: { .mock },
            appleLogin: { .mock },
            appleToken: { },
            login: { _ in },
            fetchFCMToken: { "" }
        )
    }()
    
    static var previewValue: LoginUseCase = testValue
}
