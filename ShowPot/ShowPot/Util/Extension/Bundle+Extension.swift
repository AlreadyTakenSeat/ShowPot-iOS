//
//  Bundle+Extension.swift
//  ShowPot
//
//  Created by 김도형 on 4/9/25.
//

import Foundation

extension Bundle {
    var appleKeyId: String {
        infoDictionary?["APPLE_KEY_ID"] as? String ?? ""
    }
    
    var teamId: String {
        infoDictionary?["TEAM_ID"] as? String ?? ""
    }
    
    var baseURL: String {
        infoDictionary?["BASE_URL"] as? String ?? ""
    }
    
    var kakaoNativeAppKey: String {
        infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String ?? ""
    }
}
