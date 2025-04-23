//
//  ShowsEndPoint.swift
//  ShowPot
//
//  Created by 김도형 on 4/10/25.
//

import Foundation

import Alamofire

enum ShowsEndPoint: EndPoint {
    case uninterested(ShowsInterestRequest)
    case interests(ShowsInterestRequest)
    case interestList(ShowsInterestListRequest)
    case alert(ShowsAlertRequest)
    case shows(ShowsListRequest)
    case showsDetail(ShowsDetailRequest)
    case alertReservations(ShowsReservationRequest)
    case terminatedTicketingCount
    case interestsCount
    case alertsCount
    case alertList(ShowsAlertListRequest)
    case search(ShowsSearchRequest)
    
    var path: String {
        switch self {
        case let .uninterested(model):
            return "/api/v1/shows/\(model.showId)/uninterested"
        case let .interests(model):
            return "/api/v1/shows/\(model.showId)/interests"
        case let .alert(model):
            return "/api/v1/shows/\(model.showId)/alert?ticketingApiType=\(model.ticketingApiType)"
        case .shows:
            return "/api/v1/shows"
        case let .showsDetail(model):
            return "/api/v1/shows/\(model.showId)"
        case let .alertReservations(model):
            return "/api/v1/shows/\(model.showId)/alert/reservations"
        case .terminatedTicketingCount:
            return "/api/v1/shows/terminated/ticketing/count"
        case .interestsCount:
            return "/api/v1/shows/interests/count"
        case .alertsCount:
            return "/api/v1/shows/alerts/count"
        case .alertList:
            return "/api/v1/shows/alerts"
        case .search:
            return "/api/v1/shows/search"
        case .interestList:
            return "/api/v1/shows/interests"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .uninterested,
             .interests,
             .alert:
            return .post
        case .shows,
             .showsDetail,
             .alertReservations,
             .terminatedTicketingCount,
             .interestsCount,
             .alertsCount,
             .alertList,
             .search,
             .interestList:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case let .showsDetail(model):
            return ["Device-Token": model.deviceToken]
        default: return [:]
        }
    }
    
    var decoder: JSONDecoder {
        JSONDecoder()
    }
    
    var encoder: (any ParameterEncoder)? {
        switch self {
        case .uninterested,
             .terminatedTicketingCount,
             .interestsCount,
             .alertsCount,
             .showsDetail:
            return nil
        case .alert: return .json
        case .shows,
             .alertReservations,
             .search,
             .interests,
             .alertList,
             .interestList:
            return .urlEncodedForm
        }
    }
    
    var parameters: (any Encodable)? {
        switch self {
        case .uninterested,
             .terminatedTicketingCount,
             .interestsCount,
             .alertsCount,
             .showsDetail:
            return nil
        case let .shows(model):
            return model
        case let .alertReservations(model):
            return ["ticketingApiType": model.ticketingApiType]
        case let .search(model):
            return model
        case let .interests(model):
            return model
        case let .alertList(model):
            return model
        case let .alert(model):
            return ["alertTimes": model.alertTimes]
        case let .interestList(model):
            return model
        }
    }
}
