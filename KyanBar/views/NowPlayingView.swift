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
      // Because the block is already marked as async internally
      // We can just use await. The .task modifier is also cancellable – if
      // you have an async process going on and the view goes out of scope,
      // SwiftUI will cancel the specified task automatically
      await nowPlaying.refresh()
    }
  }
}

struct NowPlayingView_Previews: PreviewProvider {
  static var previews: some View {
    NowPlayingView()
  }
}
