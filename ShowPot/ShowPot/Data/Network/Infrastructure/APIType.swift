//
//  APIType.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/26/24.
//

// TODO: #150 현재는 일정상 하나의 클래스로 개발. 데모데이 이후 최우선 리팩토링 예정

import Foundation
import Alamofire

protocol APIType {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
}

extension APIType {
    var url: String {
        return "\(baseURL)\(path)"
    }
    
    var header: HTTPHeaders? {
        guard let accessToken = try? KeyChainManager.shared.read(account: .accessToken) else {
            return nil
        }
        
        return ["Authorization": "Bearer \(accessToken)"]
    }
}
