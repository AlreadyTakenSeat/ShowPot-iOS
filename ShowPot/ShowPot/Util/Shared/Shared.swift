//
//  Shared.swift
//  ShowPot
//
//  Created by 김도형 on 4/4/25.
//

import Foundation

import RxSwift
import RxCocoa

@propertyWrapper
struct Shared<T> {
    private let type: SharedType<T>
    
    init(_ type: SharedType<T>) {
        self.type = type
    }
    
    init(wrappedValue: T, _ type: SharedType<T>) {
        self.type = type
        
        switch type {
        case .userDefaults(let key):
            if UserDefaults.standard.object(forKey: key.rawValue) == nil {
                UserDefaults.standard.set(wrappedValue, forKey: key.rawValue)
            }
        }
    }
    
    var wrappedValue: T? {
        get {
            switch type {
            case let .userDefaults(key):
                UserDefaults.standard.object(forKey: key.rawValue) as? T
            }
        }
        set {
            switch type {
            case let .userDefaults(key):
                UserDefaults.standard.set(newValue, forKey: key.rawValue)
            }
        }
    }
    
    var projectedValue: Observable<T?> {
        switch type {
        case .userDefaults(let key):
            UserDefaults.standard.rx
                .observe(T.self, key.rawValue, options: [.initial, .new])
                .share()
        }
    }
}

enum SharedType<T> {
    case userDefaults(UserDefaultKey)
}

enum UserDefaultKey: String {
    case recentQueries
    case loginPlatform
}
