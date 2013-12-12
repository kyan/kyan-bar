class JukeBoxView < NSView

  attr_accessor :jukebox

  def viewWillDraw
    update_title
    update_artist
    update_album
    update_image

    super
  end

  def track
    jukebox.track unless jukebox.nil?
  end

  private

  def update_title
    txt = track.title.nil? ? '-' : track.title
    viewWithTag(TRACK_TITLE).setStringValue(txt)
    viewWithTag(TRACK_TITLE).setToolTip(txt)
  end

  def update_artist
    txt = track.artist.nil? ? '-' : track.artist
    viewWithTag(TRACK_ARTIST).setStringValue(txt)
    viewWithTag(TRACK_ARTIST).setToolTip(txt)
  end

  def update_album
    txt = track.album.nil? ? '-' : track.album
    viewWithTag(TRACK_ALBUM).setStringValue(txt)
    viewWithTag(TRACK_ALBUM).setToolTip(txt)
  end

  def update_image
    image_url = if jukebox.track.artwork_url.nil?
      "http://www.appledystopia.com/wp-content/uploads/2013/03/missing-itunes-album-art-icon.png"
    else
      jukebox.track.artwork_url
    end

    Dispatch::Queue.concurrent.async do
      url   = NSURL.URLWithString(image_url)
      image = NSImage.alloc.initWithContentsOfURL(url)
      viewWithTag(TRACK_ARTWORK_URL).setImage(image)
    end
  end
end