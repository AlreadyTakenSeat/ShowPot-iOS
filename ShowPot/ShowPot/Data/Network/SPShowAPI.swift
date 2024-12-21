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
    
    case uninterest(showId: String)
    case interest(showId: String)
    case alert(showId: String, type: String)
    case showList
    case showDetail(showId: String)
    case reservationInfo(showId: String)
    case terminatedTicketingCount
    case searchShow
    case interestList
    case interestCount
    case alertList
    case alertCount
    
    var baseURL: String {
        return Environment.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .interest, .uninterest, .alert:
            return .post
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .uninterest(let showId):
            return "shows/\(showId)/uninterest"
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
        case .interestCount:
            return "shows/interests/count"
        case .alertList:
            return "shows/alerts"
        case .alertCount:
            return "shows/alerts/count"
        }
    }
}

class SPShowAPI {
    
    /// 관심 삭제
    func deleteInterest(showId: String) -> Observable<CommonResponse> {
        let target = SPShowTargetType.uninterest(showId: showId)
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
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
    
    /// 관심 등록
    func updateInterest(showId: String) -> Observable<CommonResponse> {
        let target = SPShowTargetType.interest(showId: showId)
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
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
    
    /// 알람 시간 요청
    func updateAlert(showId: String, date: Date, type: String = "NORMAL") -> Observable<CommonResponse> {
        let target = SPShowTargetType.alert(showId: showId, type: type)
        let request = ShowAlertRequest(alertDate: date)
        
        return Observable.create { emitter in
            AF.request(
                target.url,
                method: target.method,
                parameters: request,
                encoder: JSONParameterEncoder.default,
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
    
    func showList(sort: String, onlyOpen: Bool = false, cursorId: String? = nil, size: Int = 30) -> Observable<ShowListData> {
        
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
    
    func showDetail(showId: String) -> Observable<ShowDetailResponse> {
        let target = SPShowTargetType.showDetail(showId: showId)
        let id = UIDevice.current.identifierForVendor?.uuidString
        
        var header: HTTPHeaders = ["Device-Token": id ?? ""]
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
    
    func reservationInfo(showId: String, ticketingType: String = "NORMAL") -> Observable<ShowReservationInfoData> {
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
    
    func terminatedTicketingCount() -> Observable<ShowTerminatedTicketingCountData> {
        let target = SPShowTargetType.terminatedTicketingCount
        return Observable.create { emitter in
            
            AF.request(
                target.url,
                method: target.method,
                headers: target.header
            ).responseDecodable(of: ShowTerminatedTicketingCountResponse.self) { response in
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
    
    func search(keyword: String) -> Observable<ShowSearchData> {
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
    
    func interestList() -> Observable<ShowInterestListData> {
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
    
    // TODO: 관심 공연 개수 api/v1/shows/interests/count 구현 필요
    // TODO: 알람 공연 개수 api/v1/shows/alerts/count 구현 필요
}
