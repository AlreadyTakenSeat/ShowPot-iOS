//
//  LoginState.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/27/24.
//

import Foundation

enum LoginState {
    /// 로그인 안되어 있음
    case notLoggedIn
    /// 자동 로그인 설정이 되어있음, accessToken 갱신 필요
    case autoLoginPending
    /// 로그인 되어있음
    case loggedIn
    
    /// 현재 로그인 상태 반환
    static var current: Self = {
        
        guard TokenManager.shared.readToken(.refreshToken) != nil else {
            return .notLoggedIn
        }
        
        guard TokenManager.shared.readToken(.accessToken) != nil else {
            return .autoLoginPending
        }
        
        return .loggedIn
    }()
}
