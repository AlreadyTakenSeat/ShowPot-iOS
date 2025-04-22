//
//  ArtistEntity.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import Foundation

struct ArtistEntity: Identifiable, Hashable {
    let id: String?
    let imageURL, name: String
    let spotifyId: String?
    var isSubscribed: Bool?
}

extension ArtistEntity {
    static let mock = ArtistEntity(
        id: "01940663-c2c3-528d-6e05-674786a9cfbe",
        imageURL: "https://i.scdn.co/image/ab6761610000f178f8349dfb619a7f842242de77",
        name: "Maroon 5",
        spotifyId: "04gDigrS5kc9YWfZHwBETP",
        isSubscribed: false
    )
    
    static let mockAlarm = ArtistEntity(
        id: "01940663-c2c3-528d-6e05-674786a9cfbe",
        imageURL: "https://i.scdn.co/image/ab6761610000f178f8349dfb619a7f842242de77",
        name: "Maroon 5",
        spotifyId: "04gDigrS5kc9YWfZHwBETP",
        isSubscribed: false
    )
    
    static let mockList: [ArtistEntity] = [
        ArtistEntity(
            id: "0194256b-625b-ace3-e8c3-fbdf0f84a752",
            imageURL: "https://i.scdn.co/image/ab6761610000f1787dcc891849ed130649176966",
            name: "coldrain",
            spotifyId: "4pCVGaLWxDe4d8bsjsnmUM",
            isSubscribed: false
        ),
        ArtistEntity(
            id: "01940663-c2c3-528d-6e05-674786a9cfbe",
            imageURL: "https://i.scdn.co/image/ab6761610000f178f8349dfb619a7f842242de77",
            name: "Maroon 5",
            spotifyId: "04gDigrS5kc9YWfZHwBETP",
            isSubscribed: false
        ),
        ArtistEntity(
            id: "019424ce-785a-a6ef-a466-d2bb16d28272",
            imageURL: "https://i.scdn.co/image/ab6761610000f1780522e98a6f0cf1ddbee9a74f",
            name: "Oasis",
            spotifyId: "2DaxqgrOhkeH0fpeiQq2f4",
            isSubscribed: false
        ),
        ArtistEntity(
            id: "019424ce-7660-bc3f-6ca1-defc9c56cff7",
            imageURL: "https://i.scdn.co/image/ab6761610000f17827ea8d74714b23fa9e116f91",
            name: "Cold War Kids",
            spotifyId: "6VDdCwrBM4qQaGxoAyxyJC",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f1786cdb0d32feaeb22f9b2d64b8",
            name: "Cold Hart",
            spotifyId: "1fsCfvdiomqjKJFR6xI8e4",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f178cad2a98065e13720ce622c6c",
            name: "Cold",
            spotifyId: "0Gw3a3BkWLwsMLFbOBmo6Q",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f17809b03b5ae3ea139f92114e25",
            name: "Coldabank",
            spotifyId: "3JOvRLynmP4mA6dvlWARoA",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f178172dd518fabe8298259baab8",
            name: "Coldzy",
            spotifyId: "401ikVSob52311M6Fwnunt",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f17841da5ea9f1f138678335beed",
            name: "Cold",
            spotifyId: "3bxfOfSCLwqgMM5ThWJ5vu",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f178d022f1020f0fef2401066b8b",
            name: "Cold",
            spotifyId: "6wmWpRv8Pw9NYk5aE6xWIE",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f178c3ea6c13a3edf6df136b4a0f",
            name: "Cold Diamond & Mink",
            spotifyId: "47eOrmm0M2qY5atzSNNt2b",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f178c206123c7dcf328df8bf4d6d",
            name: "coldbrew",
            spotifyId: "7r3gH36F9O5GtmYPYymtLK",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f1789f8d5cb9948a536c04e1d8ab",
            name: "Coldiac",
            spotifyId: "42BY4cYu4ZSj37CbSYjDgA",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f1784b053c29fd4b317ff825f0dc",
            name: "J. Cole",
            spotifyId: "6l3HvQ5sa6mXTsMTB19rO5",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f178d4e38c4e3e5c82774740e28d",
            name: "Phil Collins",
            spotifyId: "4lxfqrEsLX6N1N4OCSkILp",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab67616d0000485184dc7bee9a39afe851827cdf",
            name: "cold heart",
            spotifyId: "0Cp1mVNaY8UqxSxzwNSxpW",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f178b83a29555ec43d9bf78d1b62",
            name: "The Cold Stares",
            spotifyId: "0hLLs7dOw0Z1XBFFrLSDln",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab67616d000048516741c97870eed6db31a8e63c",
            name: "Cold Water Worship",
            spotifyId: "0br91ss6BdMgZCfaX1gX7D",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f17873c7f7505c1af82929ec41df",
            name: "John Coltrane",
            spotifyId: "2hGh5VOeeqimQFxqXvfCUf",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f178eaaa12a0fdaa403a10099728",
            name: "Cold Cave",
            spotifyId: "1ssulsHf3JrWakLxa8yFad",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f178a636b0b244253f602a629796",
            name: "Ludwig van Beethoven",
            spotifyId: "2wOqMjp9TyABvtHdOSOTUS",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f178a3bc978bea1dc16de72cbe2f",
            name: "Cold Busted",
            spotifyId: "0uhd4ZyLS61oODSwmyhPfV",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f178217198d000d16d08d9b76da4",
            name: "Coldcut",
            spotifyId: "5wnhqlZzXIq8aO9awQO2ND",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f178ca5ac5e8da4e64f7d7f75720",
            name: "Cold Suhou",
            spotifyId: "1QXhYc6MzTjzg8Tq2TBceq",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f1784fcdbd1166f8598dd236c101",
            name: "coldlakes",
            spotifyId: "3jxJQ1JkYdqHNGnvIoW0nI",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f1781223464273767d64760a0a88",
            name: "Colter Wall",
            spotifyId: "3xYXYzm9H3RzyQgBrYwIcx",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f1780ec0ea710ed8ce9e490d9c7b",
            name: "Nat King Cole",
            spotifyId: "7v4imS0moSyGdXyLgVTIV7",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f1787aa4a1906e9c52118f0235b3",
            name: "coldoutlay",
            spotifyId: "6iVZjzQSsPC4iuI1JUV2Zs",
            isSubscribed: false
        ),
        ArtistEntity(
            id: nil,
            imageURL: "https://i.scdn.co/image/ab6761610000f1781ab13fdacbb8017ec4087ca9",
            name: "Keyshia Cole",
            spotifyId: "1vfezMIyCr4XUdYRaKIKi3",
            isSubscribed: false
        )
    ]
}
