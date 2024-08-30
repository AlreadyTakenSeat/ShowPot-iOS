//
//  SPShowAPI.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/29/24.
//

import Foundation
import Alamofire
import RxSwift
import UIKit

enum SPShowTargetType: APIType {
    
    case interest(showId: String)
    case alert(showId: String, type: String)
    case showList
    case showDetail(showId: String)
    case reservationInfo(showId: String)
    case terminatedTicketingCount
    case searchShow
    case interestList
    case alertList
    
    var baseURL: String {
        return Environment.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .interest, .alert:
            return .post
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .interest(let showId):
            return "shows/\(showId)/interests"
        case .alert(let showId, let type):
            return "shows/\(showId)/alert?ticketingApiType=\(type)"
        case .showList:
            return "shows"
        case .showDetail(let showId):
            return "shows/\(showId)"
        case .reservationInfo(let showId):
            return "shows/\(showId)/alert/reservations"
        case .terminatedTicketingCount:
            return "shows/terminated/ticketing/count"
        case .searchShow:
            return "show/search"
        case .interestList:
            return "shows/interests"
        case .alertList:
            return "shows/alerts"
        }
    }
}

class SPShowAPI {
    
    func updateInterest(showId: String) -> Observable<ShowInterestResponse> {
        let target = SPShowTargetType.interest(showId: showId)
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                headers: target.header
            ).responseDecodable(of: ShowInterestResponse.self) { response in
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
    
    func updateAlert(showId: String, list: [AlertTime], type: String = "NORMAL") -> Observable<Void> {
        let target = SPShowTargetType.alert(showId: showId, type: type)
        let request = ShowAlertRequest(alertTimes: list.map { $0.rawValue })
        
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: request,
                encoder: JSONParameterEncoder.default,
                headers: target.header
            ).response { response in
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
    
    func showList(sort: String, onlyOpen: Bool = false, size: Int = 100) -> Observable<ShowListResponse> {
        
        let target = SPShowTargetType.showList
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
    
    func showDetail(showId: String) -> Observable<ShowDetailResponse> {
        let target = SPShowTargetType.showDetail(showId: showId)
        
        let accessToken = try? KeyChainManager.shared.read(account: .accessToken) 
        let id = UIDevice.current.identifierForVendor?.uuidString
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")",
            "viewIdentifier": id ?? ""
        ]
        
        LogHelper.info("[\(target.method)] \(target.url)")
        
        return Observable.create { emitter in
            
            AF.request(
                target.url,
                method: target.method,
                headers: header
            ).responseDecodable(of: ShowDetailResponse.self) { response in
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
    
    func reservationInfo(showId: String, ticketingType: String = "NORMAL") -> Observable<ShowReservationInfoResponse> {
        let target = SPShowTargetType.reservationInfo(showId: showId)
        
        return Observable.create { emitter in
            
            AF.request(
                target.url,
                method: target.method,
                parameters: ["ticketingApiType": ticketingType],
                headers: target.header
            ).responseDecodable(of: ShowReservationInfoResponse.self) { response in
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
    
    func terminatedTicketingCount() -> Observable<ShowTerminatedTicketingCountResponse> {
        let target = SPShowTargetType.terminatedTicketingCount
        return Observable.create { emitter in
            
            AF.request(
                target.url,
                method: target.method,
                headers: target.header
            ).responseDecodable(of: ShowTerminatedTicketingCountResponse.self) { response in
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
    
    func search(keyword: String) -> Observable<ShowSearchResponse> {
        let target = SPShowTargetType.searchShow
        let param: Parameters = [
            "size": 100,
            "search": keyword
        ]
        
        return Observable.create { emitter in
            
            AF.request(
                target.url,
                method: target.method,
                parameters: param,
                headers: target.header
            ).responseDecodable(of: ShowSearchResponse.self) { response in
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
    
    func interestList() -> Observable<ShowInterestListResponse> {
        let target = SPShowTargetType.interestList
        let param: Parameters = ["size": 100]
        
        return Observable.create { emitter in
            
            AF.request(
                target.url,
                method: target.method,
                parameters: param,
                headers: target.header
            ).responseDecodable(of: ShowInterestListResponse.self) { response in
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
    
    func alertList(stateType: String = "CONTINUED") -> Observable<ShowAlertListResponse> {
        let target = SPShowTargetType.alertList
        let param: Parameters = [
            "size": 100,
            "type": stateType
        ]
        
        return Observable.create { emitter in
            
            AF.request(
                target.url,
                method: target.method,
                parameters: param,
                headers: target.header
            ).responseDecodable(of: ShowAlertListResponse.self) { response in
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
