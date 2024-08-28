//
//  SPSearchAPI.swift
//  ShowPot
//
//  Created by 이건준 on 8/28/24.
//

import Foundation
import Alamofire
import RxSwift

enum SPSearchTargetType: APIType {
    
    /// 아티스트 검색
    case searchArtist
    /// 공연 검색
    case searchShow
    
    var baseURL: String {
        return "\(Environment.baseURL)"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .searchArtist, .searchShow:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .searchArtist:
            return "artists/search"
        case .searchShow:
            return "shows/search"
        }
    }
    
}

final class SPSearchAPI {
    
    func searchArtist(request: SearchArtistRequest) -> Observable<SearchArtistResponse> {
        let target = SPSearchTargetType.searchArtist

        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: request
            ).responseDecodable(of: SearchArtistResponse.self) { response in
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
    
    func searchShowList(request: SearchShowRequest) -> Observable<SearchShowResponse> {
        let target = SPSearchTargetType.searchShow
        
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: request
            ).responseDecodable(of: SearchShowResponse.self) { response in
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
