//
//  UserDefaultsManager.swift
//  ShowPot
//
//  Created by Daegeon Choi on 7/23/24.
//

import Foundation

/// UserDefaults 관리 싱글톤 객체
final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    let userDefaults: UserDefaults?
    
    private init() {
        self.userDefaults = UserDefaults.standard
    }
}

// MARK: 일반 자료형 I/O
extension UserDefaultsManager {
    
    func remove(for key: UserDefaultsKey) {
        self.userDefaults?.removeObject(forKey: key.value)
    }
    
    func set<T>(_ object: T, for key: UserDefaultsKey) {
        self.userDefaults?.set(object, forKey: key.value)
    }
    
    func get<T>(for key: UserDefaultsKey) -> T? {
        let result = self.userDefaults?.object(forKey: key.value) as? T
        return result
    }
    
    func getObject(for key: UserDefaultsKey) -> Any? {
        let result = self.userDefaults?.object(forKey: key.value)
        return result
    }
}
