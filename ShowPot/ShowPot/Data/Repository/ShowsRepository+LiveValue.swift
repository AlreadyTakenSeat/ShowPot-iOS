//
//  ShowsRepository+LiveValue.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

import Dependencies

extension ShowsRepository: DependencyKey {
    static let liveValue: ShowsRepository = {
        let provider = NetworkProvider<ShowsEndPoint>()
        
        return ShowsRepository(
            uninterested: { showId in
                let request = ShowsInterestRequest(showId: showId)
                try await provider.request(.uninterested(request))
            },
            interests: { showId in
                let request = ShowsInterestRequest(showId: showId)
                try await provider.request(.interests(request))
            },
            alert: { showId, ticketingApiType, alertTimes in
                let request = ShowsAlertRequest(
                    showId: showId,
                    ticketingApiType: ticketingApiType.rawValue,
                    alertTimes: alertTimes
                )
                try await provider.request(.alert(request))
            },
            shows: { model in
                let request = model.toData()
                let response: DTO<PageResponse<ShowOpenResponse>>
                response = try await provider.requestNonToken(
                    .shows(request)
                )
                return response.data.toEntity()
            },
            showsDetail: { showId, deviceToken in
                let request = ShowsDetailRequest(showId: showId, deviceToken: deviceToken)
                do {
                    let response: DTO<ShowDetailResponse> = try await provider.request(
                        .showsDetail(request)
                    )
                    return response.data.toEntity()
                } catch SPError.tokenNotFound {
                    let response: DTO<ShowDetailResponse> = try await provider.requestNonToken(
                        .showsDetail(request)
                    )
                    return response.data.toEntity()
                } catch SPError.reissueFail {
                    let response: DTO<ShowDetailResponse> = try await provider.requestNonToken(
                        .showsDetail(request)
                    )
                    return response.data.toEntity()
                }
            },
            alertReservations: { showId, ticketingApiType in
                let request = ShowsReservationRequest(
                    showId: showId,
                    ticketingApiType: ticketingApiType.rawValue
                )
                let response: DTO<ShowReservationResponse>
                response = try await provider.request(
                    .alertReservations(request)
                )
                return response.data.toEntity()
            },
            terminatedTicketingCount: {
                let response: DTO<CountResponse>
                response = try await provider.request(
                    .terminatedTicketingCount
                )
                return response.data.count
            },
            interestsCount: {
                let response: DTO<CountResponse>
                response = try await provider.request(
                    .interestsCount
                )
                return response.data.count
            },
            alertsCount: {
                let response: DTO<CountResponse>
                response = try await provider.request(
                    .alertsCount
                )
                return response.data.count
            },
            alertList: { type, cursor, size in
                let request = ShowsAlertListRequest(
                    type: type.rawValue,
                    cursorId: cursor.id,
                    cursorValue: cursor.value,
                    size: 30
                )
                let response: DTO<PageResponse<ShowResponse>>
                response = try await provider.request(
                    .alertList(request)
                )
                return response.data.toEntity()
            },
            search: { search, cursorId, size in
                let request = ShowsSearchRequest(
                    cursorId: cursorId,
                    search: search,
                    size: size
                )
                let response: DTO<PageResponse<ShowResponse>>
                response = try await provider.requestNonToken(
                    .search(request)
                )
                return response.data.toEntity()
            }
        )
    }()
}

extension DependencyValues {
    var showsRepository: ShowsRepository {
        get { self[ShowsRepository.self] }
        set { self[ShowsRepository.self] = newValue }
    }
}
