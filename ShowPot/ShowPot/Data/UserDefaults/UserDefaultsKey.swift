//
//  UserDefaultsKey.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/23/24.
//

import Foundation

/// UserDefults에 사용할 Key값을 관리하기 위한 enum
enum UserDefaultsKey: String {
    /// 최초 실행 여부
    case firstLaunch
    
    /// 최근 검색어 리스트
    case recentSearchKeywordList
    
    /// 로그인 여부
    case isLoggedIn
    
    var value: String {
        return self.rawValue
    }
}
