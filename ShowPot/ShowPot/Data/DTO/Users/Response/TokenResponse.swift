//
//  TokenResponse.swift
//  ShowPot
//
//  Created by 김도형 on 4/9/25.
//

import Foundation

struct TokenResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
