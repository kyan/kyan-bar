//
//  NowPlaying.swift
//  kyan
//
//  Created by Duncan Robertson on 01/11/2021.
//

import SwiftUI

struct NowPlayingView: View {
  @StateObject var nowPlaying = NowPlayingModel()
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Jukebox now playing:")
        .font(.caption)
        .fontWeight(.light)
      TrackView(track: nowPlaying.currentTrack)
    }
    .padding(15)
    .task {
      await nowPlaying.refresh()
    }
  }
}

struct NowPlayingView_Previews: PreviewProvider {
  static var previews: some View {
    NowPlayingView()
  }
}
