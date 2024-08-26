//
//  APIService.swift
//  ShowPot
//
//  Created by Daegeon Choi on 5/25/24.
//

// TODO: #150 현재는 일정상 하나의 클래스로 개발. 데모데이 이후 최우선 리팩토링 예정

import Foundation
import Alamofire
import RxSwift

final class APIClient {
    
    func showList(sort: String, onlyOpen: Bool = false, size: Int = 100) -> Observable<ShowListResponse> {
        
        let target = SPTargetType.showList
        let param: Parameters = [
            "sort": sort,
            "onlyOpenSchedule": onlyOpen,
            "size": size
        ]
        
        LogHelper.info("[\(target.method)] \(target.url)")
        
        return Observable.create { emitter in
            
            AF.request(
                target.url,
                method: target.method,
                parameters: param
            ).responseDecodable(of: ShowListResponse.self) { response in
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
    
    func login(request: SignInRequest) -> Observable<SignInResponse> {
        
        let target = SPTargetType.login
        
        LogHelper.info("[\(target.method)] \(target.url)")
        LogHelper.debug("로그인 요청값: \(request)")
        
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: request,
                encoder: JSONParameterEncoder.default
            ).responseDecodable(of: SignInResponse.self) { response in
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
