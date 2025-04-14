//
//  GenreEntity.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import Foundation

struct GenreEntity: Identifiable, Hashable {
    let id: String
    let name: Genre?
    var isSubscribed: Bool
}

extension GenreEntity {
    enum Genre: String {
        case rock
        case hiphop
        case band
        case jpop
        case pop
        case house
        case edm
        case musical
        case rnb
        case opera
        case metal
        case classic
        case jazz
        
        var title: String {
            switch self {
            case .rock: return "Rock"
            case .hiphop: return "Hiphop"
            case .band: return "Band"
            case .jpop: return "Jpop"
            case .pop: return "Pop"
            case .house: return "House"
            case .edm: return "EDM"
            case .musical: return "Musical"
            case .rnb: return "Rnb"
            case .opera: return "Opera"
            case .metal: return "Metal"
            case .classic: return "Classic"
            case .jazz: return "Jazz"
            }
        }
    }
}

extension GenreEntity {
    static let mock = GenreEntity(
        id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d1",
        name: .rock,
        isSubscribed: false
    )
    
    static let mockAlarm = GenreEntity(
        id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d1",
        name: .rock,
        isSubscribed: true
    )
    
    static let mockList: [GenreEntity] = [
        GenreEntity(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d1", name: .rock, isSubscribed: false),
        GenreEntity(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d2", name: .hiphop, isSubscribed: false),
        GenreEntity(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d3", name: .band, isSubscribed: false),
        GenreEntity(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d4", name: .jpop, isSubscribed: false),
        GenreEntity(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d5", name: .pop, isSubscribed: false),
        GenreEntity(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d6", name: .house, isSubscribed: false),
        GenreEntity(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d7", name: .edm, isSubscribed: false),
        GenreEntity(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d8", name: .musical, isSubscribed: false),
        GenreEntity(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876d9", name: .rnb, isSubscribed: false),
        GenreEntity(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876da", name: .opera, isSubscribed: false),
        GenreEntity(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876db", name: .metal, isSubscribed: false),
        GenreEntity(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876dc", name: .classic, isSubscribed: false),
        GenreEntity(id: "017f20d0-4f3c-8f4d-9e15-7ff0c3a876dd", name: .jazz, isSubscribed: false)
    ]
}
