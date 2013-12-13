class NowplayingView < NSView

  attr_accessor :jukebox, :spacer, :padding

  def initWithFrame(frame)
    super(frame).tap do |cell|
      @spacer   = 5
      @padding  = 20
      @image  ||= draw_image_box
      @title  ||= draw_title_box
      @artist ||= draw_artist_box
      @album  ||= draw_album_box

      cell.addSubview @image
      cell.addSubview @title
      cell.addSubview @artist
      cell.addSubview @album
    end
  end

  def track
    jukebox.track unless jukebox.nil?
  end

  def drawRect(dirtyRect)
    update_image
    update_title
    update_artist
    update_album
  end

  private

  def start_x
    return 0 if @image.nil? || @image.isHidden
    @image.frame.origin.x + @image.frame.size.width + spacer
  end

  def end_x
    frame.origin.x + frame.size.width - padding - start_x
  end

  def draw_title_box
    NSTextField.alloc.initWithFrame([[start_x, 31], [end_x, 15]]).tap do |v|
      v.setEditable(false)
      v.setBezeled(false)
      v.setDrawsBackground(false)
      v.setSelectable(false)
    end
  end

  def draw_artist_box
    NSTextField.alloc.initWithFrame([[start_x, 14], [end_x, 15]]).tap do |v|
      v.setEditable(false)
      v.setBezeled(false)
      v.setDrawsBackground(false)
      v.setSelectable(false)
    end
  end

  def draw_album_box
    NSTextField.alloc.initWithFrame([[start_x, 5], [end_x, 10]]).tap do |v|
      v.setEditable(false)
      v.setBezeled(false)
      v.setDrawsBackground(false)
      v.setSelectable(false)
    end
  end

  def draw_image_box
    NSImageView.alloc.initWithFrame([[padding, 0], [50, 50]]).tap do |v|
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