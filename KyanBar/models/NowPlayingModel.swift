//
//  NowPlaying.swift
//  KyanBar
//
//  Created by Duncan Robertson on 10/11/2021.
//

import Foundation

class NowPlayingModel: ObservableObject {
  @Published var currentTrack: Track = .placeholder

  func load() {
    let url = URL(string: "https://kyan-jukebox-now-playing.deno.dev")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.cachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
    
    URLSession.shared.dataTask(with: request) { data, _, error in
      if let data = data {
        if let decodedResponse = try? JSONDecoder().decode(Track.self, from: data) {
          print("JSON fetched")
          
          DispatchQueue.main.async {
            self.currentTrack = decodedResponse
          }
          
          return
        }
      }
      
      print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
    }.resume()
  }
}
