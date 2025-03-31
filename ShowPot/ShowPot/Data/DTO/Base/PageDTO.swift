//
//  PageDTO.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import Foundation

struct PageDTO<T: Decodable>: Decodable {
    let size: Int
    let hasNext: Bool
    let data: [T]
}
