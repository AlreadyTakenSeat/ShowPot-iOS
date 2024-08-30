//
//  SPArtistAPI.swift
//  ShowPot
//
//  Created by 이건준 on 8/29/24.
//

import RxSwift
import Alamofire

enum SPArtistTargetType: APIType {
    
    /// 아티스트 구독
    case subscribe
    
    /// 아티스독 구독 해제
    case unsubscribe
    
    /// 구독한 아티스트 리스트
    case subscriptions
    
    /// 구독하지않은 아티스트 리스트
    case unsubscriptions
    
    var baseURL: String {
        return Environment.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .subscriptions, .unsubscriptions:
            return .get
        case .subscribe, .unsubscribe:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .subscribe:
            return "artists/subscribe"
        case .unsubscribe:
            return "artists/unsubscribe"
        case .subscriptions:
            return "artists/subscriptions"
        case .unsubscriptions:
            return "artists/unsubscriptions"
        }
    }
}

final class SPArtistAPI {
    
    func subscriptions(request: SubscribeArtistListRequest) -> Observable<ArtistListResponse> {
        
        let target = SPArtistTargetType.subscriptions
        
        LogHelper.info("[\(target.method)] \(target.url)")
        LogHelper.info("구독안한아티스트리스트 요청정보: \(request)")
        
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: request,
                headers: target.header
            ).responseDecodable(of: ArtistListResponse.self) { response in
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
    
    func unsubscriptions(request: UnsubscribeArtistListRequest) -> Observable<ArtistListResponse> {
        
        let target = SPArtistTargetType.unsubscriptions
        
        LogHelper.info("[\(target.method)] \(target.url)")
        LogHelper.info("구독안한아티스트리스트 요청정보: \(request)")
        
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: request
            ).responseDecodable(of: ArtistListResponse.self) { response in
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
    
    func unsubscribe(artistIDS: [String]) -> Observable<UnsubscribeArtistResponse> {
        let target = SPArtistTargetType.unsubscribe
        let request = UnsubscribeArtistRequest(artistIDS: artistIDS)
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: request,
                encoder: JSONParameterEncoder.default,
                headers: target.header
            ).responseDecodable(of: UnsubscribeArtistResponse.self) { response in
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
    
    func subscribe(artistIDS: [String]) -> Observable<SubscribeArtistResponse> {
        let target = SPArtistTargetType.subscribe
        let request = SubscribeArtistRequest(artistIDS: artistIDS)
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: request,
                encoder: JSONParameterEncoder.default,
                headers: target.header
            ).responseDecodable(of: SubscribeArtistResponse.self) { response in
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
