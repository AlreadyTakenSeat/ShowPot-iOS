//
//  DTO.swift
//  ShowPot
//
//  Created by 김도형 on 4/11/25.
//

import Foundation

protocol DTO {
    associatedtype Entity
    
    func toEntity() -> Entity
}
