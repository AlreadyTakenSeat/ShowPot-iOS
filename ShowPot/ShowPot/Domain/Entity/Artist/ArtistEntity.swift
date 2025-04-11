//
//  ArtistEntity.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import Foundation

struct ArtistEntity: Identifiable, Hashable {
    let id, imageURL, name: String
    var isSubscribed: Bool?
}

extension ArtistEntity {
    static let mock = ArtistEntity(
        id: "01937cf1-1ddf-9bea-0437-6e1238cf5809",
        imageURL: "https://i.scdn.co/image/ab6761610000f178e17c0aa1714a03d62b5ce4e0",
        name: "Post Malone",
        isSubscribed: nil
    )
    
    static let mockAlarm = ArtistEntity(
        id: "01937cf1-1ddf-9bea-0437-6e1238cf5809",
        imageURL: "https://i.scdn.co/image/ab6761610000f178e17c0aa1714a03d62b5ce4e0",
        name: "Post Malone",
        isSubscribed: true
    )
    
    static let mockList = [
        ArtistEntity(id: "01937cf1-1ddf-9bea-0437-6e1238cf5809", imageURL: "https://i.scdn.co/image/ab6761610000f178e17c0aa1714a03d62b5ce4e0", name: "Post Malone", isSubscribed: nil),
        ArtistEntity(id: "01937cf1-1ddf-9bea-0437-6e1238cf580a", imageURL: "https://i.scdn.co/image/ab6761610000f1781ba8fc5f5c73e7e9313cc6eb", name: "Coldplay", isSubscribed: nil),
        ArtistEntity(id: "01937cf1-1ddf-9bea-0437-6e1238cf580b", imageURL: "https://i.scdn.co/image/ab6761610000f178e03a98785f3658f0b6461ec4", name: "Olivia Rodrigo", isSubscribed: nil),
        ArtistEntity(id: "01937cf1-1ddf-9bea-0437-6e1238cf580c", imageURL: "https://i.scdn.co/image/ab6761610000f178c36dd9eb55fb0db4911f25dd", name: "Bruno Mars", isSubscribed: nil),
        ArtistEntity(id: "01937cf1-1ddf-9bea-0437-6e1238cf580d", imageURL: "https://i.scdn.co/image/ab6761610000f178e65fa0329c232ac6f5040f80", name: "AJR", isSubscribed: nil),
        ArtistEntity(id: "01940660-40db-689b-8b47-a6e706d394ad", imageURL: "https://i.scdn.co/image/ab67616d000048516907d59bb8774957fdcaca5c", name: "The Evergreen Trio", isSubscribed: nil),
        ArtistEntity(id: "01940660-40db-689b-8b47-a6e706d394ae", imageURL: "https://i.scdn.co/image/ab6761610000f17805f666b46dfb8a7a37390283", name: "SPYAIR", isSubscribed: nil),
        ArtistEntity(id: "01940660-40db-689b-8b47-a6e706d394af", imageURL: "https://i.scdn.co/image/ab6761610000f17874eee2af6bd02df43e9595cc", name: "ELLEGARDEN", isSubscribed: nil),
        ArtistEntity(id: "01940660-40db-689b-8b47-a6e706d394b0", imageURL: "https://i.scdn.co/image/ab6761610000f178ae21e90221e814c50033133a", name: "King Gizzard & The Lizard Wizard", isSubscribed: nil),
        ArtistEntity(id: "01940660-40db-689b-8b47-a6e706d394b1", imageURL: "https://i.scdn.co/image/ab6761610000f178d5594e3ae145bbb2c096366d", name: "Charlie Puth", isSubscribed: nil),
        ArtistEntity(id: "01940660-40db-689b-8b47-a6e706d394b2", imageURL: "https://i.scdn.co/image/ab6761610000f178e672b5f553298dcdccb0e676", name: "Taylor Swift", isSubscribed: nil),
        ArtistEntity(id: "01940660-40db-689b-8b47-a6e706d394b3", imageURL: "https://i.scdn.co/image/ab6761610000f1789e528993a2820267b97f6aae", name: "The Weeknd", isSubscribed: nil),
        ArtistEntity(id: "01940660-40db-689b-8b47-a6e706d394b4", imageURL: "https://i.scdn.co/image/ab6761610000f1788ae7f2aaa9817a704a87ea36", name: "Justin Bieber", isSubscribed: nil),
        ArtistEntity(id: "01940660-40db-689b-8b47-a6e706d394b5", imageURL: "https://i.scdn.co/image/ab6761610000f178f2f4aa5e873acfe27b190915", name: "Olivia Dean", isSubscribed: nil),
        ArtistEntity(id: "01940660-40db-689b-8b47-a6e706d394b6", imageURL: "https://i.scdn.co/image/ab6761610000f17843c436dd4582521e601f8099", name: "Sammy Virji", isSubscribed: nil),
        ArtistEntity(id: "01940663-c2c3-528d-6e05-674786a9cfb7", imageURL: "https://i.scdn.co/image/ab6761610000f1783faf416d3be99d63fec18baa", name: "Disclosure", isSubscribed: nil),
        ArtistEntity(id: "01940663-c2c3-528d-6e05-674786a9cfb8", imageURL: "https://i.scdn.co/image/ab6761610000f178a03696716c9ee605006047fd", name: "Radiohead", isSubscribed: nil),
        ArtistEntity(id: "01940663-c2c3-528d-6e05-674786a9cfb9", imageURL: "https://i.scdn.co/image/ab6761610000f178bac5615022cefc2ac72caec4", name: "Christopher", isSubscribed: nil),
        ArtistEntity(id: "01940663-c2c3-528d-6e05-674786a9cfba", imageURL: "https://i.scdn.co/image/ab6761610000f178c3b137793230f4043feb0089", name: "The Strokes", isSubscribed: nil),
        ArtistEntity(id: "01940663-c2c3-528d-6e05-674786a9cfbb", imageURL: "https://i.scdn.co/image/ab6761610000f178d2b2a1cea3b6b44f4bae14b2", name: "Benson Boone", isSubscribed: nil),
        ArtistEntity(id: "01940663-c2c3-528d-6e05-674786a9cfbc", imageURL: "https://i.scdn.co/image/ab6761610000f17840b5c07ab77b6b1a9075fdc0", name: "Ariana Grande", isSubscribed: nil),
        ArtistEntity(id: "01940663-c2c3-528d-6e05-674786a9cfbd", imageURL: "https://i.scdn.co/image/ab6761610000f178cc2d67917c6dc6cdfd009964", name: "Conan Gray", isSubscribed: nil),
        ArtistEntity(id: "01940663-c2c3-528d-6e05-674786a9cfbe", imageURL: "https://i.scdn.co/image/ab6761610000f178f8349dfb619a7f842242de77", name: "Maroon 5", isSubscribed: nil),
        ArtistEntity(id: "01940663-c2c3-528d-6e05-674786a9cfbf", imageURL: "https://i.scdn.co/image/ab6761610000f178ab47d8dae2b24f5afe7f9d38", name: "Imagine Dragons", isSubscribed: nil),
        ArtistEntity(id: "01940663-c2c3-528d-6e05-674786a9cfc0", imageURL: "https://i.scdn.co/image/ab6761610000f178bfdd8a29d0c6bc6950055234", name: "YOASOBI", isSubscribed: nil),
        ArtistEntity(id: "01940668-aed7-a313-feb9-4d47a6d1aa2a", imageURL: "https://i.scdn.co/image/ab6761610000f178b173d69f77530d77a991984f", name: "Lauv", isSubscribed: nil),
        ArtistEntity(id: "01940668-aed7-a313-feb9-4d47a6d1aa2b", imageURL: "https://i.scdn.co/image/ab6761610000f17890c77d2ffb0fe10130f03230", name: "LANY", isSubscribed: nil),
        ArtistEntity(id: "01940668-aed7-a313-feb9-4d47a6d1aa2c", imageURL: "https://i.scdn.co/image/ab6761610000f178c19adef627892ffdee631d1a", name: "HONNE", isSubscribed: nil),
        ArtistEntity(id: "01940668-aed7-a313-feb9-4d47a6d1aa2d", imageURL: "https://i.scdn.co/image/ab6761610000f17821544d3b4e0a00d209f56743", name: "Noel Gallagher's High Flying Birds", isSubscribed: nil),
        ArtistEntity(id: "01940668-aed7-a313-feb9-4d47a6d1aa2e", imageURL: "https://i.scdn.co/image/ab6761610000f1786ff0cd5ef2ecf733804984bb", name: "Green Day", isSubscribed: nil)
    ]
}
