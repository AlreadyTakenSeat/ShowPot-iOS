//
//  KeychainManager.swift
//  Data
//
//  Created by 김도형 on 9/3/24.
//

import Foundation

import Dependencies

final class KeychainManager {
    private let service: String = "ShowPot"
    
    func save(_ data: String, key: Key) {
        guard read(key) == nil else {
            update(data.data(using: .utf8), key: key)
            return
        }
        create(data.data(using: .utf8), key: key)
    }

    // MARK: Read Item
    func read(_ key: Key) -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key.rawValue,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        guard status != errSecItemNotFound else {
            print("🗝️ '\(key)' 항목을 찾을 수 없어요.")
            return nil
        }
        guard status == errSecSuccess else { return nil }
        print("🗝️ '\(key)' 성공!")
        guard let result = result as? Data else { return nil }
        return String(data: result, encoding: .utf8)
    }

    // MARK: Delete Item

    public func delete(_ key: Key) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key.rawValue
        ]

        let status = SecItemDelete(query)
        guard status != errSecItemNotFound else {
            print("🗝️ '\(key)' 항목을 찾을 수 없어요.")
            return
        }
        guard status == errSecSuccess else { return }
        print("🗝️ '\(key)' 성공!")
    }
    
    private func create(_ data: Data?, key: Key) {
        guard let data = data else {
            print("🗝️ '\(key)' 값이 없어요.")
            return
        }

        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key.rawValue,
            kSecValueData: data
        ]

        let status = SecItemAdd(query, nil)
        guard status == errSecSuccess else {
            print("🗝️ '\(key)' 상태 = \(status)")
            return
        }
        print("🗝️ '\(key)' 성공!")
    }
    
    // MARK: Update Item
    private func update(_ data: Data?, key: Key) {
        guard let data = data else {
            print("🗝️ '\(key)' 값이 없어요.")
            return
        }

        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key.rawValue
        ]
        let attributes: NSDictionary = [
            kSecValueData: data
        ]

        let status = SecItemUpdate(query, attributes)
        guard status == errSecSuccess else {
            print("🗝️ '\(key)' 상태 = \(status)")
            return
        }
        print("🗝️ '\(key)' 성공!")
    }
}

struct KeychainProvider {
    var save: (
        _ data: String,
        _ key: KeychainManager.Key
    ) -> Void
    var read: (
        _ key: KeychainManager.Key
    ) -> String?
    var delete: (
        _ key: KeychainManager.Key
    ) -> Void
}

extension KeychainManager {
    enum Key: String {
        case accessToken
        case refreshToken
        case appleRefreshToken
        case appleAuthorizationCode
    }
}

extension KeychainProvider: DependencyKey {
    static let liveValue: KeychainProvider = {
        let manager = KeychainManager()
        
        return KeychainProvider(
            save: manager.save,
            read: manager.read,
            delete: manager.delete
        )
    }()
}

extension DependencyValues {
    var keychainProvider: KeychainProvider {
        get { self[KeychainProvider.self] }
        set { self[KeychainProvider.self] = newValue }
    }
}
