//
//  KeyChainAccount.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/27/24.
//

import Foundation

enum KeyChainAccount {
    case accessToken
    case refreshToken
    case pushToken
    case userId
    
    var description: String {
        return String(describing: self)
    }
    
    var keyChainClass: CFString {
        switch self {
        case .accessToken, .refreshToken, .pushToken:
            return kSecClassGenericPassword
        case .userId:
            return kSecClassInternetPassword
        }
    }
}
