class NowplayingView < NSView

  attr_accessor :metrics_dict

  def initWithFrame(frame)
    super(frame).tap do |cell|
      cell.translatesAutoresizingMaskIntoConstraints = false

      @image    ||= draw_image_box
      @title    ||= draw_title_box
      @artist   ||= draw_artist_box
      @album    ||= draw_album_box
      @addedby  ||= draw_addedby_box

      views_dict = {
        "image"   => @image,
        "title"   => @title,
        "artist"  => @artist,
        "album"   => @album,
        "addedby" => @addedby
      }

      @metrics_dict = {
        "image_side"   => 50,
        "h_spacing"    => 5,
        "h_padding"    => 10,
        "v_padding"    => 5,
        "vv_padding"   => 3,
        "title_h"      => 18,
        "artist_h"     => 15,
        "album_h"      => 15,
        "addedby_h"    => 10
      }

      views_dict.each do |key, view|
        cell.addSubview(view)
      end
      cell.addSubview(@flash)

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
        "H:|-h_padding-[image(==image_side)]-h_spacing-[addedby]-h_padding-|",
        options:0,
        metrics:metrics_dict,
        views:views_dict
      )
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|-vv_padding-[title(title_h)]-(-1)-[artist(artist_h)]-(-2)-[album(album_h)]-(-3)-[addedby(addedby_h)]",
        options:0,
        metrics:metrics_dict,
        views:views_dict
      )
      cell.addConstraints(constraints)
    end
  end

  def refresh(jukebox)
    @jukebox = jukebox
    update_data!
  end

  def track
    @jukebox.track unless @jukebox.nil?
  end

  private

  def update_data!
    if @jukebox
      update_image
      update_title
      update_artist
      update_album
      update_addedby
    end

    invalidateIntrinsicContentSize
    setNeedsDisplay(true)
  end

  def draw_title_box
    NSTextField.new.tap do |v|
      v.setEditable(false)
      v.setBezeled(false)
      v.setDrawsBackground(false)
      v.setSelectable(false)
      v.setTranslatesAutoresizingMaskIntoConstraints(false)
    end
  end

  def draw_artist_box
    NSTextField.new.tap do |v|
      v.setEditable(false)
      v.setBezeled(false)
      v.setDrawsBackground(false)
      v.setSelectable(false)
      v.setTranslatesAutoresizingMaskIntoConstraints(false)
    end
  end

  def draw_album_box
    NSTextField.new.tap do |v|
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

  def draw_addedby_box
    NSTextField.new.tap do |v|
      v.setEditable(false)
      v.setBezeled(false)
      v.setDrawsBackground(false)
      v.setSelectable(false)
      v.setTranslatesAutoresizingMaskIntoConstraints(false)
    end
  end

  def update_title
    paragraph = NSMutableParagraphStyle.new
    paragraph.setLineBreakMode(NSLineBreakByTruncatingTail)

    txt = track.title.attrd({
      'NSFont' => NSFont.fontWithName("Lucida Grande", size:12),
      'NSColor' => NSColor.blackColor,
      'NSParagraphStyle' => paragraph
    }) unless track.title.nil?
    @title.setAttributedStringValue(txt)
    @title.setToolTip(track.title)
  end

  def update_artist
    paragraph = NSMutableParagraphStyle.new
    paragraph.setLineBreakMode(NSLineBreakByTruncatingTail)

    txt = track.artist.attrd({
      'NSFont' => NSFont.fontWithName("Lucida Grande", size:10),
      'NSColor' => NSColor.darkGrayColor,
      'NSParagraphStyle' => paragraph
    }) unless track.artist.nil?
    @artist.setAttributedStringValue(txt)
    @artist.setToolTip(track.artist)
  end

  def update_album
    paragraph = NSMutableParagraphStyle.new
    paragraph.setLineBreakMode(NSLineBreakByTruncatingTail)

    txt = track.album.attrd({
      'NSFont' => NSFont.fontWithName("Lucida Grande", size:10),
      'NSColor' => NSColor.grayColor,
      'NSParagraphStyle' => paragraph
    }) unless track.album.nil?
    @album.setAttributedStringValue(txt)
    @album.setToolTip(track.album)
  end

  def update_addedby
    paragraph = NSMutableParagraphStyle.new
    paragraph.setLineBreakMode(NSLineBreakByTruncatingTail)

    txt = "Added by #{track.added_by}".attrd({
      'NSFont' => NSFont.fontWithName("Lucida Grande", size:8),
      'NSColor' => NSColor.darkGrayColor,
      'NSParagraphStyle' => paragraph
    }) unless track.added_by.nil?
    @addedby.setAttributedStringValue(txt)
    @addedby.setToolTip(track.album)
  end

  def update_image
    artwork_image = NSImage.imageNamed("missing_artwork.png")
    @image.setImage(artwork_image)

    if !track.artwork_url.nil?
      gcdq = Dispatch::Queue.new('com.kyan.kyanbar')
      gcdq.async do
        url = NSURL.URLWithString(track.artwork_url)
        if url
          artwork_image = NSImage.alloc.initWithContentsOfURL(url)
          @image.setImage(artwork_image) unless artwork_image.nil?
        end
      end
    end
  end
end