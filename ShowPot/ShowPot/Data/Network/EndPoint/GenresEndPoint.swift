//
//  GenresEndPoint.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

import Alamofire

enum GenresEndPoint: EndPoint {
    case unsubscribe(GenresSubscribeRequest)
    case subscribe(GenresSubscribeRequest)
    case genreList(CursorRequest)
    case unsubscriptionList(CursorRequest)
    case subscriptionList(CursorRequest)
    case subscriptionCount
    
    var path: String {
        switch self {
        case .unsubscribe:
            return "/api/v1/genres/unsubscribe"
        case .subscribe:
            return "/api/v1/genres/subscribe"
        case .genreList:
            return "/api/v1/genres"
        case .unsubscriptionList:
            return "/api/v1/genres/unsubscriptions"
        case .subscriptionList:
            return "/api/v1/genres/subscriptions"
        case .subscriptionCount:
            return "/api/v1/genres/subscriptions/count"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .unsubscribe,
             .subscribe:
            return .post
        case .genreList,
             .unsubscriptionList,
             .subscriptionList,
             .subscriptionCount:
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
        case .genreList,
             .unsubscriptionList,
             .subscriptionList,
             .subscriptionCount:
            return .urlEncodedForm
        }
    }
    
    var parameters: (any Encodable)? {
        switch self {
        case let .unsubscribe(model):
            return model
        case let .subscribe(model):
            return model
        case let .genreList(model):
            return model
        case let .unsubscriptionList(model):
            return model
        case let .subscriptionList(model):
            return model
        case .subscriptionCount:
            return nil
        }
    }
}
