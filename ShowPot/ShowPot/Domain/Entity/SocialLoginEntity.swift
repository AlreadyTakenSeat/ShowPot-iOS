//
//  SocialLoginEntity.swift
//  ShowPot
//
//  Created by 김도형 on 4/9/25.
//

import Foundation

struct SocialLoginEntity {
    let idToken: String
    let authorizationCode: String?
    let socialType: String
    
    init(
        idToken: String,
        authorizationCode: String? = nil,
        socialType: String
    ) {
        self.idToken = idToken
        self.authorizationCode = authorizationCode
        self.socialType = socialType
    }
}

extension SocialLoginEntity {
    static let mock = SocialLoginEntity(
        idToken: "",
        socialType: "GOOGLE"
    )
}
