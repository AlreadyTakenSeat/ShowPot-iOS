//
//  ProfileEntity.swift
//  ShowPot
//
//  Created by 김도형 on 4/6/25.
//

import Foundation

struct ProfileEntity: Hashable {
    let nickname: String
    let platform: Platform?
}

extension ProfileEntity {
    enum Platform: String {
        case kakao = "KAKAO"
        case google = "GOOGLE"
        case apple = "APPLE"
        
        var name: String {
            switch self {
            case .kakao: return "카카오"
            case .google: return "구글"
            case .apple: return "애플"
            }
        }
    }
}

extension ProfileEntity {
    static let mock = ProfileEntity(nickname: "춤추는 고래", platform: .kakao)
}
