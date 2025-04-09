//
//  LoginRequest.swift
//  ShowPot
//
//  Created by 김도형 on 4/9/25.
//

import Foundation

struct LoginRequest: Encodable {
    let socialType: String
    let identifier: String
    let fcmToken: String
}

extension LoginEntity {
    func toData() -> LoginRequest {
        return LoginRequest(
            socialType: self.socialType.rawValue,
            identifier: self.identifier,
            fcmToken: self.fcmToken
        )
    }
}
