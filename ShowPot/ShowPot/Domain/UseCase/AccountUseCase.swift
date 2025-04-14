//
//  AccountUseCase.swift
//  ShowPot
//
//  Created by 김도형 on 4/13/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct AccountUseCase {
    var withdrawal: () async throws -> Void
    var logout: () async throws -> Void
    var profile: () async throws -> ProfileEntity
    var appleRevoke: () async throws -> Void
}

extension AccountUseCase: TestDependencyKey {
    static let testValue: AccountUseCase = {
        return AccountUseCase(
            withdrawal: { },
            logout: { },
            profile: { .mock },
            appleRevoke: { }
        )
    }()
}
