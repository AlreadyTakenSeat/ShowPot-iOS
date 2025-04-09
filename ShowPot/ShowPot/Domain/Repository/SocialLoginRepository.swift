//
//  SocialLoginRepository.swift
//  ShowPot
//
//  Created by 김도형 on 4/9/25.
//

import Foundation

import Dependencies

struct SocialLoginRepository {
    var googleLogin: () async throws -> SocialLoginEntity
    var kakaoLogin: () async throws -> SocialLoginEntity
    var appleLogin: () async throws -> SocialLoginEntity
    var appleToken: () async throws -> Void
    var appleRevoke: () async throws -> Void
}

extension SocialLoginRepository: TestDependencyKey {
    static let testValue: SocialLoginRepository = {
        return SocialLoginRepository(
            googleLogin: { .mock },
            kakaoLogin: { .mock },
            appleLogin: { .mock },
            appleToken: { },
            appleRevoke: { }
        )
    }()
}

extension DependencyValues {
    var socialLoginRepository: SocialLoginRepository {
        get { self[SocialLoginRepository.self] }
        set { self[SocialLoginRepository.self] = newValue }
    }
}
