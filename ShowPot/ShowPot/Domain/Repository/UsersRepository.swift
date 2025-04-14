//
//  UsersRepository.swift
//  ShowPot
//
//  Created by 김도형 on 4/9/25.
//

import Foundation

import Dependencies

struct UsersRepository {
    var withdrawal: () async throws -> Void
    var reissue: () async throws -> Void
    var logout: () async throws -> Void
    var login: (LoginEntity) async throws -> Void
    var profile: () async throws -> ProfileEntity
}
