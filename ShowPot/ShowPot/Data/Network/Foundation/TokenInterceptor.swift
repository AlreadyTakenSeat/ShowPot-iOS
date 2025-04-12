//
//  TokenInterceptor.swift
//  ShowPot
//
//  Created by 김도형 on 4/8/25.
//

import Foundation

import Alamofire
import Dependencies

final class TokenInterceptor: RequestInterceptor {
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        @Dependency(\.keychainProvider.read)
        var keychainRead
        
        var request = urlRequest
        
        guard let accessToken = keychainRead(.accessToken) else {
            completion(.failure(SPError.tokenNotFound))
            return
        }
        request.setValue(
            "Bearer \(accessToken)",
            forHTTPHeaderField: "Authorization"
        )
        completion(.success(request))
    }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        if case let AFError.requestAdaptationFailed(adaptationError) = error {
            completion(.doNotRetryWithError(adaptationError))
            return
        }
        if case let AFError.requestRetryFailed(
            retryError: retryError,
            originalError: _
        ) = error {
            completion(.doNotRetryWithError(retryError))
            return
        }
        guard let response = request.task?.response as? HTTPURLResponse else {
            completion(.doNotRetryWithError(error))
            return
        }
        guard response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        @Dependency(\.keychainProvider.read)
        var keychainRead
        @Dependency(\.keychainProvider.save)
        var keyChainSave
        let provider = NetworkProvider<UsersEndPoint>()
        
        guard let refreshToken = keychainRead(.refreshToken) else {
            completion(.doNotRetryWithError(SPError.tokenNotFound))
            return
        }
        Task {
            let response: TokenResponse = try await provider.requestNonToken(
                .reissue(refreshToken)
            )
            keyChainSave(response.accessToken, .accessToken)
            keyChainSave(response.refreshToken, .refreshToken)
            completion(.retry)
        }
    }
}
