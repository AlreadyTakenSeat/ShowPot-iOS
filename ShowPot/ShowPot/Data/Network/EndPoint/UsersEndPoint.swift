//
//  UsersEndPoint.swift
//  ShowPot
//
//  Created by 김도형 on 4/9/25.
//

import Foundation

import Alamofire

enum UsersEndPoint: EndPoint {
    case withdrawal
    case reissue(String)
    case logout
    case login(LoginRequest)
    case profile
    
    var path: String {
        switch self {
        case .withdrawal: return "/api/v1/users/withdrawal"
        case .reissue: return "/api/v1/users/reissue"
        case .login: return "/api/v1/users/login"
        case .logout: return "/api/v1/users/logout"
        case .profile: return "/api/v1/users/profile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .withdrawal,
             .reissue,
             .logout,
             .login:
            return .post
        case .profile:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .withdrawal,
             .login,
             .logout,
             .profile:
            return [:]
        case let .reissue(refreshToken):
            return ["Refresh": refreshToken]
        }
    }
    
    var decoder: JSONDecoder {
        return JSONDecoder()
    }
    
    var encoder: (any ParameterEncoder)? {
        switch self {
        case .withdrawal,
             .logout,
             .profile,
             .reissue:
            return nil
        case .login: return .json
        }
    }
    
    var parameters: (any Encodable)? {
        switch self {
        case .withdrawal,
             .logout,
             .profile,
             .reissue:
            return nil
        case let .login(model):
            return model
        }
    }
}
