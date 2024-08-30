//
//  SearchShowRequest.swift
//  ShowPot
//
//  Created by 이건준 on 8/28/24.
//

import Foundation

struct SearchShowRequest: Codable {
    let cursor: String?
    let size: Int
    let search: String    
}
