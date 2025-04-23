//
//  ShowOpenListUseCase.swift
//  ShowPot
//
//  Created by 김도형 on 4/13/25.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
struct ShowOpenListUseCase {
    var shows: (
        _ model: ShowListEntity
    ) async throws -> Pageable<ShowOpenEntity>
}

extension ShowOpenListUseCase: TestDependencyKey {
    static let testValue: ShowOpenListUseCase = {
        return ShowOpenListUseCase(
            shows: { _ in .mock(ShowOpenEntity.mockList) }
        )
    }()
    
    static var previewValue: ShowOpenListUseCase = testValue
}
