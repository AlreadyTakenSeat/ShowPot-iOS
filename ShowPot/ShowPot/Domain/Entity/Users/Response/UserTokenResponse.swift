//
//  UserTokenResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/28/24.
//

import Foundation

struct UserTokenResponse: Codable {
    let accessToken, refreshToken: String
}
