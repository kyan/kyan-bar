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
        .font(.system(.caption))
        .fontWeight(.light)
      HStack(alignment: .top) {
        AsyncImage(url: URL(string: nowPlaying.currentTrack.image)) { image in
          image.resizable()
        } placeholder: {
          ProgressView()
        }
        .frame(width: 50, height: 50)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .accessibilityLabel("Album art")
        
        VStack(alignment: .leading) {
          Text(nowPlaying.currentTrack.title)
            .fontWeight(.bold)
            .fixedSize(horizontal: false, vertical: true)
          Text(nowPlaying.currentTrack.album)
          Text(nowPlaying.currentTrack.artist).fontWeight(.light)
        }
        .font(.system(.footnote, design: .rounded))
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
    .padding(.all, 15.0)
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
