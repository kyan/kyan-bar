//
//  NowPlaying.swift
//  KyanBar
//
//  Created by Duncan Robertson on 10/11/2021.
//

import Foundation

class NowPlayingModel: ObservableObject {
  @Published var currentTrack: Track = .placeholder

  @MainActor
  func refresh() async {
    do {
      let newTrack = try await playingNow()
      self.currentTrack = newTrack
    } catch {
      print("Could not refresh. Reason: \(error.localizedDescription)")
    }
  }

  func playingNow() async throws -> Track {
    let url = URL(string: "https://kyan-jukebox-now-playing.deno.dev")!
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(Track.self, from: data)
  }
}
