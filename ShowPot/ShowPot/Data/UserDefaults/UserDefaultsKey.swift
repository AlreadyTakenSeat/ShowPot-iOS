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
    
    var value: String {
        return self.rawValue
    }
}
