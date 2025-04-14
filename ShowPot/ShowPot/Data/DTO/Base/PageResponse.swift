//
//  PageDTO.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import Foundation

struct PageResponse<T: Decodable & Entitiable>: Decodable, Entitiable {
    typealias Entity = Pageable<T.Entity>
    
    let size: Int
    let hasNext: Bool
    let data: [T]
    let cursor: Cursor?
}

extension PageResponse {
    struct Cursor: Decodable, Entitiable {
        typealias Entity = Pageable<T.Entity>.Cursor
        
        let id: String?
        let value: String?
        
        enum CodingKeys: CodingKey {
            case id
            case value
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<PageResponse<T>.Cursor.CodingKeys> = try decoder.container(
                keyedBy: PageResponse<T>.Cursor.CodingKeys.self
            )
            self.id = try? container.decodeIfPresent(
                String.self,
                forKey: PageResponse<T>.Cursor.CodingKeys.id
            )
            self.value = try container.decodeIfPresent(
                String.self,
                forKey: PageResponse<T>.Cursor.CodingKeys.value
            )
        }
    }
}

extension PageResponse.Cursor {
    func toEntity() -> Pageable<T.Entity>.Cursor {
        return Pageable.Cursor(
            id: self.id,
            value: self.value
        )
    }
}

extension PageResponse {
    func toEntity() -> Entity {
        return Pageable(
            size: self.size,
            hasNext: self.hasNext,
            data: self.data.map { $0.toEntity() },
            cursor: self.cursor?.toEntity()
        )
    }
}
