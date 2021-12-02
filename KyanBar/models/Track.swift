//
//  Track.swift
//  KyanBar
//
//  Created by Scott Matthewman on 19/11/2021.
//

import Foundation

struct Track: Decodable {
    let title: String
    let artist: String
    let album: String
    let image: String
}

extension Track {
    // A construction of `Track` that can be used when no data has
    // been loaded.
    static let placeholder = Track(title: "Loading...", artist: "", album: "", image: "")
}
