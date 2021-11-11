//
//  NowPlaying.swift
//  kyan
//
//  Created by Duncan Robertson on 01/11/2021.
//

import SwiftUI

struct NowPlayingView: View {
  @StateObject var nowPlaying = NowPlaying()
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Jukebox now playing:")
        .font(.system(.caption, design: .rounded))
        .fontWeight(.light)
      HStack(alignment: .top) {
        AsyncImage(url: URL(string: nowPlaying.image)) { image in
          image.resizable()
        } placeholder: {
          ProgressView()
            .frame(width: 50, height: 50)
        }
        .frame(width: 50, height: 50)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .accessibilityLabel("Album art")
        
        VStack(alignment: .leading) {
          Text(nowPlaying.title)
            .fontWeight(.bold)
            .fixedSize(horizontal: false, vertical: true)
          Text(nowPlaying.album)
          Text(nowPlaying.artist)
        }
        .font(.system(.footnote, design: .rounded))
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
    .padding(.all, 15.0)
    .onAppear() {
      nowPlaying.load()
    }
  }
}

struct NowPlayingView_Previews: PreviewProvider {
  static var previews: some View {
    NowPlayingView()
  }
}
