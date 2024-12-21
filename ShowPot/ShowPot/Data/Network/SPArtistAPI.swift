//
//  SPArtistAPI.swift
//  ShowPot
//
//  Created by 이건준 on 8/29/24.
//

import RxSwift
import Alamofire

enum SPArtistTargetType: APIType {
    
    case subscribe
    case unsubscribe
    case subscriptions
    case unsubscriptions
    case subscriptionCount
    
    var baseURL: String {
        return Environment.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .subscriptions, .unsubscriptions:
            return .get
        default:
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
        case .subscriptionCount:
            return "artists/subscriptions/count"
        }
    }
}

final class SPArtistAPI {
    
    func subscriptions(request: SubscribeArtistListRequest) -> Observable<ArtistListData> {
        
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
    
    func unsubscriptions(request: UnsubscribeArtistListRequest) -> Observable<ArtistListData> {
        
        let target = SPArtistTargetType.unsubscriptions
        
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
    
    func unsubscribe(artistIDS: [String]) -> Observable<UnsubscribeArtistData> {
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
    
    func subscribe(artistIDS: [String]) -> Observable<SubscribeArtistData> {
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
    
    func subscribtionCount() -> Observable<Int> {
        let target = SPArtistTargetType.subscriptionCount
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                headers: target.header
            ).responseDecodable(of: ShowTerminatedTicketingCountResponse.self) { response in
                switch response.result {
                case .success(let data):
                    emitter.onNext(data.data.count)
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
