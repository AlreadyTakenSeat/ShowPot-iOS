//
//  SPGenreAPI.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/27/24.
//

import Foundation
import Alamofire
import RxSwift

enum SPGenreTargetType: APIType {
    
    /// 구독 취소
    case unsubscribe
    /// 구독 추가
    case subscribe
    /// 장르 리스트
    case genres
    /// 미구독 장르 리스트
    case unsubscriptions
    /// 구독 장르 리스트
    case subscriptions
    
    var baseURL: String {
        return "\(Environment.baseURL)/genres"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .unsubscribe, .subscribe:
            return .post
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .unsubscribe:
            return "unsubscribe"
        case .subscribe:
            return "subscribe"
        case .genres:
            return "genres"
        case .unsubscriptions:
            return "unsubscriptions"
        case .subscriptions:
            return "subscriptions"
        }
    }
    
}

final class SPGenreAPI {
    
    func unsubscribe(genreIDS: [String]) -> Observable<GenreUnsubscribeResponse> {
        let target = SPGenreTargetType.unsubscribe
        let request = GenreUnsubscribeRequest(genreIDS: genreIDS)
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: request,
                encoder: JSONParameterEncoder.default,
                headers: target.header
            ).responseDecodable(of: GenreUnsubscribeResponse.self) { response in
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
    
    func subscribe(genreIDS: [String]) -> Observable<GenreSubscribeResponse> {
        let target = SPGenreTargetType.subscribe
        let request = GenreSubscribeRequest(genreIDS: genreIDS)
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: request,
                encoder: JSONParameterEncoder.default,
                headers: target.header
            ).responseDecodable(of: GenreSubscribeResponse.self) { response in
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
    
    func genres() -> Observable<GenreListResponse> {
        let target = SPGenreTargetType.genres
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: ["size": 100]
            ).responseDecodable(of: GenreListResponse.self) { response in
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
    
    func unsubscriptions() -> Observable<GenreListResponse> {
        let target = SPGenreTargetType.unsubscriptions
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: ["size": 100]
            ).responseDecodable(of: GenreListResponse.self) { response in
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
    
    func subscriptions() -> Observable<GenreListResponse> {
        let target = SPGenreTargetType.subscriptions
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: ["size": 100]
            ).responseDecodable(of: GenreListResponse.self) { response in
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