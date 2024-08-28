//
//  UserLoginRequest.swift
//  ShowPot
//
//  Created by Daegeon Choi on 8/28/24.
//

import Foundation

struct UserLoginRequest: Codable {
    let socialType, identifier, fcmToken: String
}
