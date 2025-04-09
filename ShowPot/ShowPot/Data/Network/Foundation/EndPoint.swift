//
//  EndPoint.swift
//  CoinCo
//
//  Created by 김도형 on 3/7/25.
//

import Foundation

import Alamofire

protocol EndPoint: URLRequestConvertible {
    var baseURL: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var decoder: JSONDecoder { get }
    var encoder: ParameterEncoder? { get }
    var parameters: Encodable? { get }
//    func error(_ statusCode: Int?, data: Data) -> Error
}

extension EndPoint {
    var baseURL: URL? {
        return URL(string: Bundle.main.baseURL)
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL?.asURL().appendingPathComponent(path)
        guard let url else {
            throw AFError.invalidURL(url: (baseURL?.absoluteString ?? "") + "/\(path)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.headers = headers
        if let encoder, let parameters {
            request = try encoder.encode(parameters, into: request)
        }
        return request
    }
    
//    func error(_ statusCode: Int?, data: Data) -> Error {
//        return
//    }
}

enum SPError: Error {
    case tokenNotFound
}
