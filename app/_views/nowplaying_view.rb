class NowplayingView < NSView

  attr_accessor :metrics_dict

  def initWithFrame(frame)
    super(frame).tap do |cell|
      @image  ||= draw_image_box
      @title  ||= draw_title_box
      @artist ||= draw_artist_box
      @album  ||= draw_album_box

      views_dict = {
        "image"  => @image,
        "title"  => @title,
        "artist" => @artist,
        "album"  => @album
      }

      @metrics_dict = {
        "image_side"   => 50,
        "h_spacing"    => 5,
        "h_padding"    => 10,
        "v_padding"    => 5,
        "vv_padding"   => 6,
        "title_h"      => 18,
        "artist_h"     => 16,
        "album_h"      => 15
      }

      views_dict.each do |key, view|
        cell.addSubview(view)
      end

      constraints = []
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|-v_padding-[image(==image_side)]-v_padding-|",
        options:NSLayoutFormatAlignAllLeft,
        metrics:metrics_dict,
        views:views_dict
      )
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-h_padding-[image(==image_side)]-h_spacing-[title]-h_padding-|",
        options:0,
        metrics:metrics_dict,
        views:views_dict
      )
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-h_padding-[image(==image_side)]-h_spacing-[artist]-h_padding-|",
        options:0,
        metrics:metrics_dict,
        views:views_dict
      )
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-h_padding-[image(==image_side)]-h_spacing-[album]-h_padding-|",
        options:0,
        metrics:metrics_dict,
        views:views_dict
      )
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|-vv_padding-[title(title_h)]-(-1)-[artist(artist_h)]-(-2)-[album(album_h)]",
        options:0,
        metrics:metrics_dict,
        views:views_dict
      )
      cell.addConstraints(constraints)
    end
  end

  def refresh(jukebox)
    @jukebox = jukebox
    setNeedsDisplay(true)
  end

  def track
    @jukebox.track unless @jukebox.nil?
  end

  def drawRect(dirtyRect)
    if @jukebox
      update_image
      update_title
      update_artist
      update_album
    end
  end

  private

  def draw_title_box
    NSTextField.new.tap do |v|
      v.cell.setWraps(false)
      v.cell.setLineBreakMode(NSLineBreakByTruncatingTail)
      v.setEditable(false)
      v.setBezeled(false)
      v.setDrawsBackground(false)
      v.setSelectable(false)
      v.setTranslatesAutoresizingMaskIntoConstraints(false)
    end
  end

  def draw_artist_box
    NSTextField.new.tap do |v|
      v.cell.setWraps(false)
      v.cell.setLineBreakMode(NSLineBreakByTruncatingTail)
      v.setEditable(false)
      v.setBezeled(false)
      v.setDrawsBackground(false)
      v.setSelectable(false)
      v.setTranslatesAutoresizingMaskIntoConstraints(false)
    end
  end

  def draw_album_box
    NSTextField.new.tap do |v|
      v.cell.setWraps(false)
      v.cell.setLineBreakMode(NSLineBreakByTruncatingTail)
      v.setEditable(false)
      v.setBezeled(false)
      v.setDrawsBackground(false)
      v.setSelectable(false)
      v.setTranslatesAutoresizingMaskIntoConstraints(false)
    end
  end

  def draw_image_box
    NSImageView.new.tap do |v|
      v.setTranslatesAutoresizingMaskIntoConstraints(false)
      v.setEditable(false)
    end
  end

  def update_title
    txt = track.title.attrd({
      'NSFont' => NSFont.fontWithName("Lucida Grande", size:12),
      'NSColor' => NSColor.blackColor
    }) unless track.title.nil?
    @title.setAttributedStringValue(txt)
    @title.setToolTip(track.title)
  end

  def update_artist
    txt = track.artist.attrd({
      'NSFont' => NSFont.fontWithName("Lucida Grande", size:10),
      'NSColor' => NSColor.darkGrayColor
    }) unless track.artist.nil?
    @artist.setAttributedStringValue(txt)
    @artist.setToolTip(track.artist)
  end

  def update_album
    txt = track.album.attrd({
      'NSFont' => NSFont.fontWithName("Lucida Grande", size:10),
      'NSColor' => NSColor.lightGrayColor
    }) unless track.album.nil?
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