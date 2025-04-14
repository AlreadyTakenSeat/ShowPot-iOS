//
//  ShowOpenListUseCase+LiveValue.swift
//  ShowPot
//
//  Created by 김도형 on 4/13/25.
//

import Foundation

import Dependencies

extension ShowOpenListUseCase: DependencyKey {
    static let liveValue: ShowOpenListUseCase = {
        @Dependency(\.showsRepository.shows)
        var shows
        
        return ShowOpenListUseCase(
            shows: shows
        )
    }()
}
