//
//  SocialLoginRepository+LiveValue.swift
//  ShowPot
//
//  Created by 김도형 on 4/9/25.
//

import Foundation

import Dependencies

extension SocialLoginRepository: DependencyKey {
    static let liveValue: SocialLoginRepository = {
        @Dependency(\.keychainProvider.read)
        var keychainRead
        @Dependency(\.keychainProvider.save)
        var keychainSave
        
        let manager = SocialLoginManager()
        let provider = NetworkProvider<SocialEndPoint>()
        
        return SocialLoginRepository(
            googleLogin: {
                try await manager.googleLogin().toEntity()
            },
            kakaoLogin: {
                try await manager.kakaoLogin().toEntity()
            },
            appleLogin: {
                let response = try await manager.appleLogin().toEntity()
                guard let code = response.authorizationCode else {
                    return response
                }
                keychainSave(code, .appleAuthorizationCode)
                return response
            },
            appleToken: {
                let code = keychainRead(.appleAuthorizationCode) ?? ""
                let request = AppleTokenRequest(
                    clientSecret: manager.makeJWT(),
                    code: code
                )
                try await provider.requestNonToken(.appleToken(request))
            },
            appleRevoke: {
                let token = keychainRead(.appleRefreshToken) ?? ""
                let request = AppleRevokeRequest(
                    clientSecret: manager.makeJWT(),
                    token: token
                )
                try await provider.requestNonToken(.appleRevoke(request))
            }
        )
    }()
}

extension DependencyValues {
    var socialLoginRepository: SocialLoginRepository {
        get { self[SocialLoginRepository.self] }
        set { self[SocialLoginRepository.self] = newValue }
    }
}
