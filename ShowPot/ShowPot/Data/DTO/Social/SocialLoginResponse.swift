//
//  SocialLoginResponse.swift
//  ShowPot
//
//  Created by 김도형 on 4/8/25.
//

import Foundation

struct SocialLoginResponse {
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

extension SocialLoginResponse {
    func toEntity() -> SocialLoginEntity {
        return SocialLoginEntity(
            idToken: idToken,
            authorizationCode: authorizationCode,
            socialType: SocialLoginEntity.SocialType(rawValue: socialType)
        )
    }
}
