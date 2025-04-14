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
    let socialType: SocialType?
    
    init(
        idToken: String,
        authorizationCode: String? = nil,
        socialType: SocialType?
    ) {
        self.idToken = idToken
        self.authorizationCode = authorizationCode
        self.socialType = socialType
    }
}

extension SocialLoginEntity {
    enum SocialType: String {
        case apple = "APPLE"
        case google = "GOOGLE"
        case kakao = "KAKAO"
    }
}

extension SocialLoginEntity {
    static let mock = SocialLoginEntity(
        idToken: "",
        socialType: .google
    )
}
