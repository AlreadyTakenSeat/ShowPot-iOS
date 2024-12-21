//
//  SPSearchAPI.swift
//  ShowPot
//
//  Created by 이건준 on 8/28/24.
//

import Foundation
import Alamofire
import RxSwift

// FIXME: 삭제 후 카테고리에 맞는 TargetType 및 API에서만 사용되도록 수정 필요
enum SPSearchTargetType: APIType {
    
    /// 아티스트 검색
    case searchArtist(cursor: Int, size: Int, search: String)
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
        case .searchArtist(let cursor, let size, let search):
            return "artists/search?cursorId=\(cursor)&size=\(size)&search=\(search)"
        case .searchShow:
            return "shows/search"
        }
    }
    
}

final class SPSearchAPI {
    
    func searchArtist(cursor: Int = 0, size: Int = 30, search: String) -> Observable<SearchArtistData> {
        let target = SPSearchTargetType.searchArtist(cursor: cursor, size: size, search: search)

        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method
            ).responseDecodable(of: SearchArtistResponse.self) { response in
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
    
    func searchShowList(request: SearchShowRequest) -> Observable<SearchShowData> {
        let target = SPSearchTargetType.searchShow
        
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: request
            ).responseDecodable(of: SearchShowResponse.self) { response in
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
