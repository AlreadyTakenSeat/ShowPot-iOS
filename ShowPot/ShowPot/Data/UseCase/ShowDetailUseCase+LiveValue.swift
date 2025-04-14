//
//  ShowDetailUseCase+LiveValue.swift
//  ShowPot
//
//  Created by 김도형 on 4/12/25.
//

import Foundation

import Dependencies

extension ShowDetailUseCase: DependencyKey {
    static let liveValue: ShowDetailUseCase = {
        @Dependency(\.showsRepository.showsDetail)
        var showDetail
        @Dependency(\.showsRepository.alertReservations)
        var alertReservations
        @Dependency(\.showsRepository.uninterested)
        var uninterested
        @Dependency(\.showsRepository.interests)
        var interests
        @Dependency(\.showsRepository.alert)
        var alert
        @Dependency(\.firebaseRepository.fetchFCMToken)
        var fetchFCMToken
        
        return ShowDetailUseCase(
            showsDetail: showDetail,
            alertReservations: alertReservations,
            uninterested: uninterested,
            interests: interests,
            alert: alert,
            fetchFCMToken: fetchFCMToken
        )
    }()
}
