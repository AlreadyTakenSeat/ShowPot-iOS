//
//  FirebaseRepository.swift
//  ShowPot
//
//  Created by 김도형 on 4/9/25.
//

import Foundation

struct FirebaseRepository {
    var configureFirebase: () -> Void
    var updateAPNSToken: (_ deviceToken: Data) -> Void
    var fetchFCMToken: () async throws -> String
}
