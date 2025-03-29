//
//  SignInRequest.swift
//  ShowPot
//
//  Created by 이건준 on 8/27/24.
//

import Foundation

struct SignInRequest: Codable {
    let socialType: String
    let identifier: String
    let fcmToken: String
}
