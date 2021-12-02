//
//  NowPlaying.swift
//  KyanBar
//
//  Created by Duncan Robertson on 10/11/2021.
//

import Foundation

class NowPlayingModel: ObservableObject {
  // Define currentTrack and set to .placeholder as default
  // When this is change it will publish this change to any ui
  // using it.
  @Published var currentTrack: Track = .placeholder

  @MainActor
  func refresh() async {
    do {
      // Fetch the now playing data
      let newTrack = try await playingNow()
      // Assign to currentTrack
      self.currentTrack = newTrack
    } catch {
      print("Could not refresh. Reason: \(error.localizedDescription)")
    }
  }

  func playingNow() async throws -> Track {
    // create a url object
    let url = URL(string: "https://kyan-jukebox-now-playing.deno.dev")!
    // fetch the url asyncronously. Look! only a single line!
    let (data, _) = try await URLSession.shared.data(from: url)
    // Attempt to decode the JSON result
    return try JSONDecoder().decode(Track.self, from: data)
  }
}
