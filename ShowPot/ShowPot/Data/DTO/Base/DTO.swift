//
//  BaseDTO.swift
//  ShowPot
//
//  Created by 김도형 on 3/31/25.
//

import Foundation

struct DTO<T: Decodable>: Decodable {
    let code: Int
    let message: String
    let data: T
}
