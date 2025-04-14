//
//  LoginEntity.swift
//  ShowPot
//
//  Created by 김도형 on 4/9/25.
//

import Foundation

struct LoginEntity {
    let socialType: SocialType
    let identifier: String
    let fcmToken: String
}

extension LoginEntity {
    enum SocialType: String {
        case apple = "APPLE"
        case google = "GOOGLE"
        case kakao = "KAKAO"
    }
}
