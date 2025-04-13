//
//  NetworkProvider.swift
//  CoinCo
//
//  Created by 김도형 on 3/7/25.
//

import Foundation

import Alamofire

struct NetworkProvider<E: EndPoint>: Sendable {
    func request<T: Decodable>(_ endPoint: E) async throws -> T {
#if DEBUG
        try? NetworkLogger.request(endPoint)
#endif
        let response = await AF.request(
            endPoint,
            interceptor: TokenInterceptor()
        )
        .validate(statusCode: 200..<300)
        .serializingDecodable(T.self, decoder: endPoint.decoder)
        .response
#if DEBUG
        try? NetworkLogger.response(response)
#endif
        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            if case let AFError.requestRetryFailed(
                    retryError: retryError,
                    originalError: _
            ) = error {
                throw retryError
            }
            throw error
        }
    }
    
    func request(_ endPoint: E) async throws {
#if DEBUG
        try? NetworkLogger.request(endPoint)
#endif
        let response = await AF.request(
            endPoint,
            interceptor: TokenInterceptor()
        )
        .validate(statusCode: 200..<300)
        .serializingData()
        .response
#if DEBUG
        try NetworkLogger.response(response)
#endif
        switch response.result {
        case .success: return
        case .failure(let error):
            if case let AFError.requestRetryFailed(
                    retryError: retryError,
                    originalError: _
            ) = error {
                throw retryError
            }
            if case .responseSerializationFailed(.inputDataNilOrZeroLength) = error,
               response.response?.statusCode == 200 {
                // 빈 응답을 성공으로 처리
                return
            }
            throw error
        }
    }
    
    func requestNonToken<T: Decodable>(_ endPoint: E) async throws -> T {
#if DEBUG
        try? NetworkLogger.request(endPoint)
#endif
        let response = await AF.request(endPoint)
            .validate(statusCode: 200..<300)
            .serializingDecodable(T.self, decoder: endPoint.decoder)
            .response
#if DEBUG
        try NetworkLogger.response(response)
#endif
        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
    
    func requestNonToken(_ endPoint: E) async throws {
#if DEBUG
        try? NetworkLogger.request(endPoint)
#endif
        let response = await AF.request(endPoint)
            .validate(statusCode: 200..<300)
            .serializingData()
            .response
#if DEBUG
        try? NetworkLogger.response(response)
#endif
        switch response.result {
        case .success: return
        case .failure(let error):
            if case .responseSerializationFailed(.inputDataNilOrZeroLength) = error,
               response.response?.statusCode == 200 {
                // 빈 응답을 성공으로 처리
                return
            }
            throw error
        }
    }
}
