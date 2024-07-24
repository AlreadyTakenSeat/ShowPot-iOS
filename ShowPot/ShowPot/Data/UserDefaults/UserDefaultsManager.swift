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
    
}

// MARK: 커스텀 객체 I/O
extension UserDefaultsManager {
    
    func set<T>(_ value: T?, forKey key: UserDefaultsKey) where T: Encodable {
        guard let tempValue = value else {
            userDefaults?.set(nil, forKey: key.value)
            return
        }
        
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(tempValue) else {
            userDefaults?.set(nil, forKey: key.value)
            return
        }
        
        let json = String(data: jsonData, encoding: .utf8)
        userDefaults?.set(json, forKey: key.value)
    }
    
    func get<T: Decodable>(objectForkey key: UserDefaultsKey, type: T.Type) -> T? {
        let jsonString = userDefaults?.object(forKey: key.value) as? String
        let jsonData = jsonString?.data(using: .utf8)
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: jsonData ?? Data())
    }
}
