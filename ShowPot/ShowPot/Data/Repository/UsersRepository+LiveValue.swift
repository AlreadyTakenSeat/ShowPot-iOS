//
//  UsersRepository+LiveValue.swift
//  ShowPot
//
//  Created by 김도형 on 4/9/25.
//

import Foundation

import Dependencies

extension UsersRepository: DependencyKey {
    static let liveValue: UsersRepository = {
        @Dependency(\.keychainProvider.read)
        var keychainRead
        @Dependency(\.keychainProvider.save)
        var keychainSave
        @Dependency(\.keychainProvider.delete)
        var keychainDelete
        @Shared(.userDefaults(.loginPlatform))
        var loginPlatform: String?
        
        let provider = NetworkProvider<UsersEndPoint>()
        
        return UsersRepository(
            withdrawal: {
                keychainDelete(.accessToken)
                keychainDelete(.refreshToken)
                try await provider.request(.withdrawal)
            },
            reissue: {
                let refreshToken = keychainRead(.refreshToken) ?? ""
                do {
                    let response: DTO<TokenResponse> = try await provider.requestNonToken(.reissue(refreshToken))
                    let reissue = response.data
                    keychainSave(reissue.accessToken, .accessToken)
                    keychainSave(reissue.refreshToken, .refreshToken)
                } catch {
                    keychainDelete(.accessToken)
                    keychainDelete(.refreshToken)
                    throw SPError.reissueFail
                }
            },
            logout: {
                keychainDelete(.accessToken)
                keychainDelete(.refreshToken)
                try await provider.request(.logout)
            },
            login: { model in
                let response: DTO<TokenResponse> = try await provider.requestNonToken(.login(model.toData()))
                let reissue = response.data
                keychainSave(reissue.accessToken, .accessToken)
                keychainSave(reissue.refreshToken, .refreshToken)
                loginPlatform = model.socialType.rawValue
            },
            profile: {
                let response: DTO<ProfileResponse> = try await provider.request(.profile)
                return response.data.toEntity()
            }
        )
    }()
}

extension DependencyValues {
    var usersRepository: UsersRepository {
        get { self[UsersRepository.self] }
        set { self[UsersRepository.self] = newValue }
    }
}
