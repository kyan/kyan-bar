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
        "image"     => @image,
        "title"     => @title,
        "artist"    => @artist,
        "album"     => @album,
        "addedby"   => @addedby
      }

      @metrics_dict = {
        "padding"      => GLOBAL_H_PADDING,
        "vpadding"     => 5,
        "image_side"   => 50,
        "h_spacing"    => 5,
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
        "V:|-vpadding-[image(==image_side)]|",
        options:NSLayoutFormatAlignAllLeft,
        metrics:metrics_dict,
        views:views_dict
      )
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-padding-[image(==image_side)]-h_spacing-[title]-padding-|",
        options:0,
        metrics:metrics_dict,
        views:views_dict
      )
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-padding-[image(==image_side)]-h_spacing-[artist]-padding-|",
        options:0,
        metrics:metrics_dict,
        views:views_dict
      )
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-padding-[image(==image_side)]-h_spacing-[album]-padding-|",
        options:0,
        metrics:metrics_dict,
        views:views_dict
      )
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-padding-[image(==image_side)]-h_spacing-[addedby]-padding-|",
        options:0,
        metrics:metrics_dict,
        views:views_dict
      )
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|-vpadding-[title(title_h)]-(-2)-[artist(artist_h)]-(-3)-[album(album_h)]-(-3)-[addedby(addedby_h)]",
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

  def rating
    @jukebox.rating unless @jukebox.nil?
  end

  def time
    @jukebox.time
  end

  private

  def valid_jb_data?(key)
    @jukebox.whats_changed.include?(key)
  end

  def should_update?
    valid_jb_data?(:track) || valid_jb_data?(:rating)
  end

  def update_data!
    if @jukebox && should_update?
      update_image
      update_title
      update_artist
      update_album
      update_addedby
      update_votes
      update_progress
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
      v.setContentCompressionResistancePriority(
        NSLayoutPriorityDefaultLow,
        forOrientation:NSLayoutConstraintOrientationHorizontal
      )
      v.cell.setBackgroundStyle(NSBackgroundStyleRaised)
    end
  end

  def draw_artist_box
    NSTextField.new.tap do |v|
      v.setEditable(false)
      v.setBezeled(false)
      v.setDrawsBackground(false)
      v.setSelectable(false)
      v.setTranslatesAutoresizingMaskIntoConstraints(false)
      v.setContentCompressionResistancePriority(
        NSLayoutPriorityDefaultLow,
        forOrientation:NSLayoutConstraintOrientationHorizontal
      )
      v.cell.setBackgroundStyle(NSBackgroundStyleRaised)
    end
  end

  def draw_album_box
    NSTextField.new.tap do |v|
      v.setEditable(false)
      v.setBezeled(false)
      v.setDrawsBackground(false)
      v.setSelectable(false)
      v.setTranslatesAutoresizingMaskIntoConstraints(false)
      v.setContentCompressionResistancePriority(
        NSLayoutPriorityDefaultLow,
        forOrientation:NSLayoutConstraintOrientationHorizontal
      )
      v.cell.setBackgroundStyle(NSBackgroundStyleRaised)
    end
  end

  def draw_image_box
    AlbumArtView.new
  end

  def draw_addedby_box
    NSTextField.new.tap do |v|
      v.setEditable(false)
      v.setBezeled(false)
      v.setDrawsBackground(false)
      v.setSelectable(false)
      v.setTranslatesAutoresizingMaskIntoConstraints(false)
      v.setContentCompressionResistancePriority(
        NSLayoutPriorityDefaultLow,
        forOrientation:NSLayoutConstraintOrientationHorizontal
      )
      v.cell.setBackgroundStyle(NSBackgroundStyleRaised)
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
    @artist.invalidateIntrinsicContentSize
    @artist.setToolTip(track.artist)
  end

  def update_album
    paragraph = NSMutableParagraphStyle.new
    paragraph.setLineBreakMode(NSLineBreakByTruncatingTail)

    txt = track.album.attrd({
      'NSFont' => NSFont.fontWithName("Lucida Grande", size:9),
      'NSColor' => NSColor.grayColor,
      'NSParagraphStyle' => paragraph
    }) unless track.album.nil?
    @album.setAttributedStringValue(txt)
    @album.invalidateIntrinsicContentSize
    @album.setToolTip(track.album)
  end

  def update_addedby
    paragraph = NSMutableParagraphStyle.new
    paragraph.setLineBreakMode(NSLineBreakByTruncatingTail)

    txt = "#{CHOSEN_BY_TXT} #{track.added_by}".attrd({
      'NSFont' => NSFont.fontWithName("Lucida Grande", size:8),
      'NSColor' => NSColor.darkGrayColor,
      'NSParagraphStyle' => paragraph
    }) unless track.added_by.nil?
    @addedby.setAttributedStringValue(txt)
    @addedby.invalidateIntrinsicContentSize
    @addedby.setToolTip(track.album)
  end

  def update_image
    set_missing_artwork
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

  def set_missing_artwork
    @image.setImage(
      NSImage.imageNamed("missing_artwork.png")
    )
  end

  def update_votes
    score = if valid_jb_data?(:rating)
      rating.rating unless rating.nil?
    elsif valid_jb_data?(:track)
      track.rating unless track.nil?
    end
    update_vote_txt

    @image.handle_vote(score, rating)
  end

  def update_vote_txt
    if superview
      vote_txt_view = superview.viewWithTag(VOTE_TXT_VIEW)

      if !vote_txt_view.nil?
        vote_txt_view.refresh!(rating)
      end
    end
  end

  def update_progress
    if superview
      progress_view = superview.viewWithTag(PROGRESS_VIEW)

      if !progress_view.nil?
        progress_view.refresh!(track, time)
      end
    end
  end
end