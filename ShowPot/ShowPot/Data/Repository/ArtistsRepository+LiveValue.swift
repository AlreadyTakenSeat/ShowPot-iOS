//
//  ArtistsRepository+LiveValue.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

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
            artistList: { cursor in
                let request = cursor.toData()
                let response: PageDTO<ArtistResponse> = try await provider.requestNonToken(
                    .artistList(request)
                )
                return response.toEntity()
            },
            unsubscriptionList: { cursor in
                let request = cursor.toData()
                let response: PageDTO<ArtistResponse> = try await provider.request(
                    .unsubscriptionList(request)
                )
                return response.toEntity()
            },
            subscriptionList: { cursor in
                let request = cursor.toData()
                let response: PageDTO<ArtistResponse> = try await provider.request(
                    .subscriptionList(request)
                )
                return response.toEntity()
            },
            subscriptionCount: {
                let response: CountResponse = try await provider.request(
                    .subscriptionCount
                )
                return response.count
            },
            search: { cursor, search in
                let request = ArtistSearchRequest(
                    search: search,
                    cursorId: cursor.cursorId,
                    size: cursor.size
                )
                let response: PageDTO<ArtistResponse> = try await provider.request(
                    .search(request)
                )
                return response.toEntity()
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
