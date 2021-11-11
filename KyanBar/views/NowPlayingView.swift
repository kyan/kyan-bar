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
            .font(.system(.subheadline, design: .rounded))
            .fontWeight(.bold)
          Text(nowPlaying.album)
            .font(.system(.footnote, design: .rounded))
          Text(nowPlaying.artist)
            .font(.system(.footnote, design: .rounded))
        }
        .frame(alignment: .leading)
      }
    }
    .padding(.horizontal, 10.0)
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
