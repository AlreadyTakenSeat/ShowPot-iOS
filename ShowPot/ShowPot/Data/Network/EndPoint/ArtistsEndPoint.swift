//
//  ArtistsEndPoint.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

import Alamofire

enum ArtistsEndPoint: EndPoint {
    case unsubscribe(ArtistSubscribeRequest)
    case subscribe(ArtistSubscribeRequest)
    case unsubscriptionList(CursorRequest)
    case subscriptionList(CursorRequest)
    case subscriptionCount
    case search(ArtistSearchRequest)
    
    var path: String {
        switch self {
        case .unsubscribe:
            return "api/v1/artists/unsubscribe"
        case .subscribe:
            return "api/v1/artists/subscribe"
        case .unsubscriptionList:
            return "api/v1/artists/unsubscriptions"
        case .subscriptionList:
            return "api/v1/artists/subscriptions"
        case .subscriptionCount:
            return "api/v1/artists/subscriptions/count"
        case .search:
            return "api/v1/artists/search"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .unsubscribe,
             .subscribe:
            return .post
        case .unsubscriptionList,
             .subscriptionList,
             .subscriptionCount,
             .search:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        return [:]
    }
    
    var decoder: JSONDecoder {
        JSONDecoder()
    }
    
    var encoder: (any ParameterEncoder)? {
        switch self {
        case .unsubscribe,
             .subscribe:
            return .json
        case .unsubscriptionList,
             .subscriptionList,
             .subscriptionCount,
             .search:
            return .urlEncodedForm
        }
    }
    
    var parameters: (any Encodable)? {
        switch self {
        case let .unsubscribe(model):
            return model
        case let .subscribe(model):
            return model
        case let .unsubscriptionList(model):
            return model
        case let .subscriptionList(model):
            return model
        case .subscriptionCount:
            return nil
        case let .search(model):
            return model
        }
    }
}
