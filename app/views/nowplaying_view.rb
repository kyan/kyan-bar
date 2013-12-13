class NowplayingView < NSView

  attr_accessor :jukebox

  def initWithFrame(frame)
    super(frame).tap do |cell|
      @title  ||= draw_title_box
      @artist ||= draw_artist_box
      @album  ||= draw_album_box
      @image  ||= draw_image_box

      cell.addSubview @title
      cell.addSubview @artist
      cell.addSubview @album
      cell.addSubview @image
    end
  end

  def track
    jukebox.track unless jukebox.nil?
  end

  def drawRect(dirtyRect)
    update_title
    update_artist
    update_album
    update_image
  end

  private

  def draw_title_box
    NSTextField.alloc.initWithFrame([[65, 30], [160, 18]]).tap do |v|
      v.setEditable(false)
      v.setBezeled(false)
      v.setDrawsBackground(false)
      v.setSelectable(false)
    end
  end

  def draw_artist_box
    NSTextField.alloc.initWithFrame([[65, 13], [160, 18]]).tap do |v|
      v.setEditable(false)
      v.setBezeled(false)
      v.setDrawsBackground(false)
      v.setSelectable(false)
    end
  end

  def draw_album_box
    NSTextField.alloc.initWithFrame([[65, 0], [150, 16]]).tap do |v|
      v.setEditable(false)
      v.setBezeled(false)
      v.setDrawsBackground(false)
      v.setSelectable(false)
    end
  end

  def draw_image_box
    NSImageView.alloc.initWithFrame([[10, 0], [50, 50]]).tap do |v|
      v.setEditable(false)
    end
  end

  def update_title
    txt = track.title.attrd({
      'NSFont' => NSFont.fontWithName("Lucida Grande", size:12),
      'NSColor' => NSColor.blackColor
    })
    @title.setAttributedStringValue(txt)
    @title.setToolTip(track.title)
  end

  def update_artist
    txt = track.artist.attrd({
      'NSFont' => NSFont.fontWithName("Lucida Grande", size:10),
      'NSColor' => NSColor.darkGrayColor
    })
    @artist.setAttributedStringValue(txt)
    @artist.setToolTip(track.artist)
  end

  def update_album
    txt = track.album.attrd({
      'NSFont' => NSFont.fontWithName("Lucida Grande", size:10),
      'NSColor' => NSColor.lightGrayColor
    })
    @album.setAttributedStringValue(txt)
    @album.setToolTip(track.album)
  end

  def update_image
    image_url = if track.artwork_url.nil?
      "http://www.appledystopia.com/wp-content/uploads/2013/03/missing-itunes-album-art-icon.png"
    else
      track.artwork_url
    end

    Dispatch::Queue.concurrent.async do
      url   = NSURL.URLWithString(image_url)
      image = NSImage.alloc.initWithContentsOfURL(url)
      @image.setImage(image)
    end
  end
end