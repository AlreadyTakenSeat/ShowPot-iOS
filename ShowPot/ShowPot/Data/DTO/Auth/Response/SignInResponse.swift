//
//  SignInResponse.swift
//  ShowPot
//
//  Created by 이건준 on 8/27/24.
//

import Foundation

struct SignInResponse: Codable {
    let accessToken: String
    let refreshToken: String
}
