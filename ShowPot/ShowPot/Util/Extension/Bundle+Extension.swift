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
#if DEBUG
        infoDictionary?["BASE_URL"] as? String ?? ""
#elseif RELEASE
        infoDictionary?["BASE_URL_PROD"] as? String ?? ""
#endif
    }
    
    var kakaoNativeAppKey: String {
        infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String ?? ""
    }
}
