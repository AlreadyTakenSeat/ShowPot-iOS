//
//  TokenManager.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/27/24.
//

import Foundation
import RxSwift

class TokenManager {
  
    static let shared = TokenManager()
    
    private init() {}
    
    func reissue(completion: @escaping (Result<String, Error>) -> Void) {
        // TODO: refreshToken으로 accessToken 재발행 후 키체인에 저장
        // TokenManager.shared.setAccessToken(accessToken)
    }
    
    func createTokens(accessToken: String, refreshToken: String) {
        do {
            try KeyChainManager.shared.create(account: .accessToken, data: accessToken)
            try KeyChainManager.shared.create(account: .refreshToken, data: refreshToken)
        } catch {
            LogHelper.error("\(error.localizedDescription): \(error)")
        }
    }
    
    func createPushTokens(pushToken: String) {
        do {
            try KeyChainManager.shared.create(account: .pushToken, data: pushToken)
        } catch {
            LogHelper.error("\(error.localizedDescription): \(error)")
        }
    }
    
    func setToken(_ token: String, for account: KeyChainAccount) {
        do {
            try KeyChainManager.shared.create(account: account, data: token)
        } catch {
            LogHelper.error("\(error.localizedDescription): \(error)")
        }
    }
    
    func readToken(_ account: KeyChainAccount) -> String? {
        do {
            let token = try KeyChainManager.shared.read(account: account)
            return token
        } catch {
            LogHelper.error("\(error.localizedDescription): \(error)")
            return nil
        }
    }
    
    func deleteTokens() {
        do {
            try KeyChainManager.shared.delete(account: .accessToken)
            try KeyChainManager.shared.delete(account: .refreshToken)
        } catch {
            LogHelper.error("\(error.localizedDescription): \(error)")
        }
    }
    
}
