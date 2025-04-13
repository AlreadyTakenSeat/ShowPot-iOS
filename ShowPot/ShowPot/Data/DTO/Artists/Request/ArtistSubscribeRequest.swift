//
//  SubscribeArtistRequest.swift
//  ShowPot
//
//  Created by 이건준 on 8/29/24.
//

import Foundation

struct ArtistSubscribeRequest: Encodable {
    let spotifyArtistIds: [String]
}

struct ArtistUnsubwscribeRequest: Encodable {
    let artistIds: [String]
}
