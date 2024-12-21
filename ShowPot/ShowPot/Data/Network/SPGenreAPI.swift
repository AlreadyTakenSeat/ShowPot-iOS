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
    /// 구독한 장르 수
    case subscriptionCount
    
    var baseURL: String {
        return "\(Environment.baseURL)"
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
            return "genres/unsubscribe"
        case .subscribe:
            return "genres/subscribe"
        case .genres:
            return "genres"
        case .unsubscriptions:
            return "genres/unsubscriptions"
        case .subscriptions:
            return "genres/subscriptions"
        case .subscriptionCount:
            return "genres/subscriptions/count"
        }
    }
    
}

final class SPGenreAPI {
    
    func unsubscribe(genreIDS: [String]) -> Observable<GenreUnsubscribeData> {
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
    
    func subscribe(genreIDS: [String]) -> Observable<GenreSubscribeData> {
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
    
    func genres() -> Observable<GenreListData> {
        let target = SPGenreTargetType.genres
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: ["size": 100],
                headers: target.header
            ).responseDecodable(of: GenreListResponse.self) { response in
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
    
    func unsubscriptions() -> Observable<GenreListData> {
        let target = SPGenreTargetType.unsubscriptions
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: ["size": 100]
            ).responseDecodable(of: GenreListResponse.self) { response in
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
    
    func subscriptions() -> Observable<GenreListData> {
        let target = SPGenreTargetType.subscriptions
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: ["size": 100]
            ).responseDecodable(of: GenreListResponse.self) { response in
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
    
    func subscriptionCount() -> Observable<Int> {
        let target = SPGenreTargetType.genres
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: ["size": 100],
                headers: target.header
            ).responseDecodable(of: GenreListResponse.self) { response in
                switch response.result {
                case .success(let data):
                    emitter.onNext(data.data.data.count)
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
