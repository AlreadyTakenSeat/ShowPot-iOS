//
//  SPUserAPI.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/28/24.
//

import Foundation
import Alamofire
import RxSwift

enum SPUserTargetType: APIType {
    
    case withdrawal
    case reissueToken
    case logout
    case login
    case profileInfo
    
    var baseURL: String {
        return Environment.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .profileInfo:
            return .get
        default:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .withdrawal:
            return "users/withdrawal"
        case .reissueToken:
            return "users/reissue"
        case .logout:
            return "users/logout"
        case .login:
            return "users/login"
        case .profileInfo:
            return "users/profile"
        }
    }
}

final class SPUserAPI {
    
    func withdrawal() -> Observable<Void> {
        let target = SPUserTargetType.withdrawal
        let request = UserAccessRequest(accessToken: TokenManager.shared.readToken(.accessToken) ?? "")
        
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: request,
                encoder: JSONParameterEncoder.default,
                headers: target.header
            ).responseDecodable(of: GenreUnsubscribeResponse.self) { response in
                switch response.result {
                case .success:
                    emitter.onNext(())
                    emitter.onCompleted()
                case .failure(let error):
                    LogHelper.error("\(error.localizedDescription): \(error)")
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func reissueToken() -> Observable<UserTokenResponse> {
        let target = SPUserTargetType.reissueToken
        let request = UserRefreshRequest(refreshToken: TokenManager.shared.readToken(.refreshToken) ?? "")
        
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: request,
                encoder: JSONParameterEncoder.default
            ).responseDecodable(of: UserTokenResponse.self) { response in
                switch response.result {
                case .success(let data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case .failure(let error):
                    LogHelper.error("\(error.localizedDescription): \(error)")
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func login(socialType: String, identifier: String) -> Observable<UserTokenResponse> {
        let target = SPUserTargetType.login
        let fcmToken = TokenManager.shared.readToken(.pushToken) ?? ""
        let request = UserLoginRequest(socialType: socialType, identifier: identifier, fcmToken: fcmToken)
        
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: request,
                encoder: JSONParameterEncoder.default,
                headers: target.header
            ).responseDecodable(of: UserTokenResponse.self) { response in
                switch response.result {
                case .success(let data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case .failure(let error):
                    LogHelper.error("\(error.localizedDescription): \(error)")
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func profileInfo() -> Observable<UserProfileResponse> {
        let target = SPUserTargetType.profileInfo
        
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                headers: target.header
            ).responseDecodable(of: UserProfileResponse.self) { response in
                switch response.result {
                case .success(let data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case .failure(let error):
                    LogHelper.error("\(error.localizedDescription): \(error)")
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
