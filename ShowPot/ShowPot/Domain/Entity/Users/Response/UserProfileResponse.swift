//
//  UserProfileResponse.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/28/24.
//

import Foundation

struct UserProfileResponse: Codable {
    let code: Int
    let message: String
    let data: UserProfileData
}

struct UserProfileData: Codable {
    let nickname, type: String
}
