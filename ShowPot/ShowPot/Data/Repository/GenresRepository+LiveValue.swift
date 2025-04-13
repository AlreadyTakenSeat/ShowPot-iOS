//
//  GenresRepository+LiveValue.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

import Dependencies

extension GenresRepository: DependencyKey {
    static let liveValue: GenresRepository = {
        let provider = NetworkProvider<GenresEndPoint>()
        
        return GenresRepository(
            unsubscribe: { genreIds in
                let request = GenresSubscribeRequest(genreIds: genreIds)
                try await provider.request(.unsubscribe(request))
            },
            subscribe: { genreIds in
                let request = GenresSubscribeRequest(genreIds: genreIds)
                try await provider.request(.subscribe(request))
            },
            genreList: { cursor in
                let request = cursor.toData()
                let response: DTO<PageResponse<GenreResponse>>
                do {
                    response = try await provider.request(
                        .genreList(request)
                    )
                } catch SPError.tokenNotFound {
                    response = try await provider.requestNonToken(
                        .genreList(request)
                    )
                } catch SPError.reissueFail {
                    response = try await provider.requestNonToken(
                        .genreList(request)
                    )
                }
                return response.data.toEntity()
            },
            unsubscriptionList: { cursor in
                let request = cursor.toData()
                let response: DTO<PageResponse<GenreResponse>>
                response = try await provider.request(
                    .unsubscriptionList(request)
                )
                return response.data.toEntity()
            },
            subscriptionList: { cursor in
                let request = cursor.toData()
                let response: DTO<PageResponse<GenreResponse>>
                response = try await provider.request(
                    .subscriptionList(request)
                )
                return response.data.toEntity()
            },
            subscriptionCount: {
                let response: DTO<CountResponse>
                response = try await provider.request(
                    .subscriptionCount
                )
                return response.data.count
            }
        )
    }()
}

extension DependencyValues {
    var genresRepository: GenresRepository {
        get { self[GenresRepository.self] }
        set { self[GenresRepository.self] = newValue }
    }
}
