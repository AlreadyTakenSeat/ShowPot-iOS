//
//  SPTargetType.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/26/24.
//

// TODO: #150 현재는 일정상 하나의 클래스로 개발. 데모데이 이후 최우선 리팩토링 예정

import Foundation
import Alamofire

// TODO: Sample 이기 때문에 추후 sample case 삭제 예정
enum SPTargetType: APIType {
    
    case showList
    
    var baseURL: String {
        return Environment.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .showList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .showList:
            return "shows"
        }
    }
}
