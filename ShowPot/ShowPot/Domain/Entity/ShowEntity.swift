//
//  ShowSearchEntity.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import Foundation

struct ShowEntity: Identifiable, Hashable {
    let id, title, startAt, endAt: String
    let location, imageURL: String
}

extension ShowEntity {
    static let mock: [ShowEntity] = [
        ShowEntity(
            id: "01937cf9-9c48-4ac9-1c57-8aba45fd4a96",
            title: "Post malone 공연1",
            startAt: "2025-03-04 19:00", // Assumed start time
            endAt: "2025-03-04 21:00",   // Assumed end time
            location: "서울 잠실",
            imageURL: "https://showpot.s3.ap-northeast-2.amazonaws.com/show/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202024-09-10%20%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB%2011.33.52_1732968553281.png"
        ),
        ShowEntity(
            id: "01937cfa-8fb0-9491-7ea7-9ce4e630ce14",
            title: "Post malone 공연2",
            startAt: "2025-03-04 19:00",
            endAt: "2025-03-04 21:00",
            location: "서울 잠실",
            imageURL: "https://showpot.s3.ap-northeast-2.amazonaws.com/show/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202024-10-20%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%201.55.42_1732968615663.png"
        ),
        ShowEntity(
            id: "01937cfd-0fc4-61b0-1e61-2529b72090d1",
            title: "Coldplay 공연1",
            startAt: "2025-03-04 19:00",
            endAt: "2025-03-04 21:00",
            location: "서울 잠실",
            imageURL: "https://showpot.s3.ap-northeast-2.amazonaws.com/show/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202024-11-21%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%2010.22.46_1732968779518.png"
        ),
        ShowEntity(
            id: "01937cfe-5b84-3371-3a7e-b42bc7f01e1c",
            title: "Coldplay 공연2 ",
            startAt: "2025-03-04 19:00",
            endAt: "2025-03-04 21:00",
            location: "서울 잠실",
            imageURL: "https://showpot.s3.ap-northeast-2.amazonaws.com/show/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202024-11-21%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%2010.22.46_1732968864483.png"
        ),
        ShowEntity(
            id: "01937cff-5d76-b7a9-287c-9f3bbabbe0c6",
            title: "Olivia Rodrigo 공연1",
            startAt: "2025-03-04 19:00",
            endAt: "2025-03-04 21:00",
            location: "서울 잠실",
            imageURL: "https://showpot.s3.ap-northeast-2.amazonaws.com/show/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202024-09-10%20%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB%2011.33.52_1732968930507.png"
        ),
        ShowEntity(
            id: "01937d00-10ea-0792-4d21-e9588ac9344b",
            title: "Olivia Rodrigo 공연2",
            startAt: "2025-03-04 19:00",
            endAt: "2025-03-04 21:00",
            location: "서울 잠실",
            imageURL: "https://showpot.s3.ap-northeast-2.amazonaws.com/show/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202024-10-20%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%201.55.42_1732968976457.png"
        ),
        ShowEntity(
            id: "01937d01-0358-516e-a16f-fe2e30017cac",
            title: "Bruno Mars 공연1",
            startAt: "2025-03-04 19:00",
            endAt: "2025-03-04 21:00",
            location: "서울 잠실",
            imageURL: "https://showpot.s3.ap-northeast-2.amazonaws.com/show/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202024-10-20%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%201.55.42_1732969038561.png"
        ),
        ShowEntity(
            id: "01937d01-e4a6-7d9b-dbf1-128cfb018783",
            title: "Bruno Mars 공연2",
            startAt: "2025-03-04 19:00",
            endAt: "2025-03-04 21:00",
            location: "서울 잠실",
            imageURL: "https://showpot.s3.ap-northeast-2.amazonaws.com/show/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202024-10-20%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%201.55.42_1732969096164.png"
        ),
        ShowEntity(
            id: "01937d02-d452-b277-3ea3-fb71d3887122",
            title: "AJR 공연1",
            startAt: "2025-03-04 19:00",
            endAt: "2025-03-04 21:00",
            location: "서울 잠실",
            imageURL: "https://showpot.s3.ap-northeast-2.amazonaws.com/show/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202024-09-10%20%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB%2011.33.52_1732969156590.png"
        ),
        ShowEntity(
            id: "01937d05-17e3-3985-b7cf-0241e238c2d0",
            title: "AJR 공연2",
            startAt: "2025-03-04 19:00",
            endAt: "2025-03-04 21:00",
            location: "서울 망포",
            imageURL: "https://showpot.s3.ap-northeast-2.amazonaws.com/show/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202024-10-20%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%201.55.42_1732969305874.png"
        )
    ]
}
