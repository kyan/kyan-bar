//
//  TrackView.swift
//  KyanBar
//
//  Created by Scott Matthewman on 19/11/2021.
//

import SwiftUI

struct TrackView: View {
  var track: Track

  var body: some View {
    HStack(alignment: .top) {
      AsyncImage(url: URL(string: track.image)) { image in
        image.resizable()
      } placeholder: {
        ProgressView()
      }
      .frame(width: 50, height: 50)
      .clipShape(RoundedRectangle(cornerRadius: 5))
      .accessibilityLabel("Album art")

      VStack(alignment: .leading) {
        Text(track.title)
          .fontWeight(.bold)
          .fixedSize(horizontal: false, vertical: true)
        Text("\(track.album) (\(track.year))")
        Text(track.artist).fontWeight(.light)
      }
      .font(.system(.footnote, design: .rounded))
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

// Add DEBUG line to fix bug where you can't archive the app
// due to `Track.example` not being available
#if DEBUG
struct TrackView_Previews: PreviewProvider {
  static var previews: some View {
    TrackView(track: Track.example)
  }
}
#endif
