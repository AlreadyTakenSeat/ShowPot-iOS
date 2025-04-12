//
//  ArtistsRepository+LiveValue.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

import Alamofire
import Dependencies

extension ArtistsRepository: DependencyKey {
    static let liveValue: ArtistsRepository = {
        let provider = NetworkProvider<ArtistsEndPoint>()
        
        return ArtistsRepository(
            unsubscribe: { genreIds in
                let request = ArtistSubscribeRequest(artistIds: genreIds)
                try await provider.request(.unsubscribe(request))
            },
            subscribe: { genreIds in
                let request = ArtistSubscribeRequest(artistIds: genreIds)
                try await provider.request(.subscribe(request))
            },
            unsubscriptionList: { cursor in
                let request = cursor.toData()
                let response: DTO<PageResponse<ArtistResponse>>
                do {
                    response = try await provider.request(
                        .unsubscriptionList(request)
                    )
                    return response.data.toEntity()
                } catch SPError.tokenNotFound {
                    response = try await provider.requestNonToken(
                        .unsubscriptionList(request)
                    )
                    return response.data.toEntity()
                } catch SPError.reissueFail {
                    response = try await provider.requestNonToken(
                        .unsubscriptionList(request)
                    )
                    return response.data.toEntity()
                }
            },
            subscriptionList: { cursor in
                let request = cursor.toData()
                let response: DTO<PageResponse<ArtistResponse>>
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
            },
            search: { cursor, search in
                let request = ArtistSearchRequest(
                    search: search,
                    cursorId: cursor.cursorId,
                    size: cursor.size
                )
                let response: DTO<PageResponse<ArtistResponse>>
                response = try await provider.request(
                    .search(request)
                )
                return response.data.toEntity()
            }
        )
    }()
}

extension DependencyValues {
    var artistsRepository: ArtistsRepository {
        get { self[ArtistsRepository.self] }
        set { self[ArtistsRepository.self] = newValue }
    }
}
