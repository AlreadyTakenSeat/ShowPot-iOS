//
//  MyPageUseCase.swift
//  ShowPot
//
//  Created by 김도형 on 4/13/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct MyPageUseCase {
    var profile: () async throws -> ProfileEntity
    var artistsSubscriptionCount: () async throws -> Int
    var genresSubscriptionCount: () async throws -> Int
}

extension MyPageUseCase: TestDependencyKey {
    static let testValue: MyPageUseCase = {
        return MyPageUseCase(
            profile: { .mock },
            artistsSubscriptionCount: { 0 },
            genresSubscriptionCount: { 0 }
        )
    }()
}
