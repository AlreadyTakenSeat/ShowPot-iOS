//
//  PageDTO.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import Foundation

struct PageDTO<T: Decodable & DTO>: Decodable, DTO {
    typealias Entity = Pageable<T.Entity>
    
    let size: Int
    let hasNext: Bool
    let data: [T]
    let cursor: Cursor?
}

extension PageDTO {
    struct Cursor: Decodable, DTO {
        typealias Entity = Pageable<T.Entity>.Cursor
        
        let id: String
        let value: String?
    }
}

extension PageDTO.Cursor {
    func toEntity() -> Pageable<T.Entity>.Cursor {
        return Pageable.Cursor(
            id: self.id,
            value: self.value
        )
    }
}

extension PageDTO {
    func toEntity() -> Entity {
        return Pageable(
            size: self.size,
            hasNext: self.hasNext,
            data: self.data.map { $0.toEntity() },
            cursor: self.cursor?.toEntity()
        )
    }
}
