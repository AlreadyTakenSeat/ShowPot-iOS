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
    case notificaitons
    case notificationExist
    
    var baseURL: String {
        return Environment.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .profileInfo, .notificaitons, .notificationExist:
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
        case .notificaitons:
            return "users/notifications"
        case .notificationExist:
            return "users/notifications/exist"
        }
    }
}

final class SPUserAPI {
    
    func withdrawal() -> Observable<CommonResponse> {
        let target = SPUserTargetType.withdrawal
        let request = UserAccessRequest(accessToken: TokenManager.shared.readToken(.accessToken) ?? "")
        
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: request,
                headers: target.header
            ).responseDecodable(of: CommonResponse.self) { response in
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
    
    func reissueToken() -> Observable<UserTokenData> {
        let target = SPUserTargetType.reissueToken
        
        var header: HTTPHeaders = ["Refresh": TokenManager.shared.readToken(.refreshToken) ?? ""]
        if let targetHeader = target.header {
            targetHeader.forEach { headerItem in
                header[headerItem.name] = headerItem.value
            }
        }
        
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                headers: header
            ).responseDecodable(of: UserTokenResponse.self) { response in
                switch response.result {
                case .success(let data):
                    emitter.onNext(data.data)
                    emitter.onCompleted()
                case .failure(let error):
                    LogHelper.error("\(error.localizedDescription): \(error)")
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func login(socialType: String, identifier: String) -> Observable<UserTokenData> {
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
                    emitter.onNext(data.data)
                    emitter.onCompleted()
                case .failure(let error):
                    LogHelper.error("\(error.localizedDescription): \(error)")
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func logout() -> Observable<CommonResponse> {
        let target = SPUserTargetType.logout
        let request = UserAccessRequest(accessToken: TokenManager.shared.readToken(.accessToken) ?? "")
        
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: request,
                headers: target.header
            ).responseDecodable(of: CommonResponse.self) { response in
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
    
    func profileInfo() -> Observable<UserProfileData> {
        let target = SPUserTargetType.profileInfo
        
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                headers: target.header
            ).responseDecodable(of: UserProfileResponse.self) { response in
                switch response.result {
                case .success(let data):
                    emitter.onNext(data.data)
                    emitter.onCompleted()
                case .failure(let error):
                    LogHelper.error("\(error.localizedDescription): \(error)")
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func notificationList() -> Observable<UserNotificationData> {
        let target = SPUserTargetType.notificaitons
        
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                headers: target.header
            ).responseDecodable(of: UserNotificationResponse.self) { response in
                switch response.result {
                case .success(let data):
                    emitter.onNext(data.data)
                    emitter.onCompleted()
                case .failure(let error):
                    LogHelper.error("\(error.localizedDescription): \(error)")
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func notificationExist() -> Observable<Bool> {
        let target = SPUserTargetType.notificaitons
        
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                headers: target.header
            ).responseDecodable(of: UserNotificationExistResponse.self) { response in
                switch response.result {
                case .success(let data):
                    emitter.onNext(data.data.isExist)
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
