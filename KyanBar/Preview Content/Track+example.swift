//
//  Track+example.swift
//  KyanBar
//
//  Created by Scott Matthewman on 19/11/2021.
//

import Foundation

extension Track {
  static var example: Track = {
    let url = Bundle.main.url(forResource: "exampleTrack", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    return try! JSONDecoder().decode(Track.self, from: data)
  }()
}
