//
//  UsersNotificationsEndPoint.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

import Alamofire

enum UsersNotificationsEndPoint: EndPoint {
    case notificationList(CursorRequest)
    case exist
    
    var path: String {
        switch self {
        case .notificationList:
            return "/api/v1/users/notifications"
        case .exist:
            return "/api/v1/users/notifications/exist"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .notificationList,
             .exist:
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
        case .notificationList:
            return .urlEncodedForm
        case .exist: return nil
        }
    }
    
    var parameters: (any Encodable)? {
        switch self {
        case let .notificationList(model):
            return model
        case .exist: return nil
        }
    }
}
