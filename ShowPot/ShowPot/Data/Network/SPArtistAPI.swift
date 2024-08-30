//
//  SPArtistAPI.swift
//  ShowPot
//
//  Created by 이건준 on 8/29/24.
//

import Foundation
import Alamofire

enum SPArtistTargetType: APIType {
    
    /// 아티스트 구독
    case subscribe
    
    /// 아티스독 구독 해제
    case unsubscribe
    
    /// 구독한 아티스트 리스트
    case subscriptions
    
    /// 구독하지않은 아티스트 리스트
    case unsubscriptions
    
    var baseURL: String {
        return Environment.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .subscriptions, .unsubscriptions:
            return .get
        case .subscribe, .unsubscribe:
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
        }
    }
}
