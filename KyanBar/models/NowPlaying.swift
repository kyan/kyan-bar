//
//  NowPlaying.swift
//  KyanBar
//
//  Created by Duncan Robertson on 10/11/2021.
//

import Foundation

struct NowPlayingJson: Decodable {
  let title: String
  let artist: String
  let album: String
  let image: String
}

class NowPlaying: ObservableObject {
  @Published var title = "..."
  @Published var artist = "..."
  @Published var album = "..."
  @Published var image = ""
  
  func load() {
    //let url = URL(string: "https://kyan-jukebox-now-playing.deno.dev")!
    let url = URL(string: "http://localhost:8080")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
    
    URLSession.shared.dataTask(with: request) { data, _, error in
      if let data = data {
        if let decodedResponse = try? JSONDecoder().decode(NowPlayingJson.self, from: data) {
          print("JSON fetched")
          
          DispatchQueue.main.async {
            self.title = decodedResponse.title
            self.artist = decodedResponse.artist
            self.album = decodedResponse.album
            self.image = decodedResponse.image
          }
          
          return
        }
      }
      
      print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
    }.resume()
  }
}
