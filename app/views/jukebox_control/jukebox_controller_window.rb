class JukeboxControlWindow < NSWindow

  def self.build
    alloc.initWithContentRect([[50, 50], [290, 80]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: true
    ).tap do |win|
      win.build_views
    end
  end

  def registerVote button
    VoteHandler.register(button.vote)
  end

  def artworkView
    @artworkView ||= NSImageView.alloc.init.tap do |artworkView|
      artworkView.translatesAutoresizingMaskIntoConstraints = false
      artworkView.setImage NSImage.alloc.initWithContentsOfFile("#{NSBundle.mainBundle.resourcePath}/missing_artwork.png")
    end
  end

  def new_artwork artworkView
    artworkView.setImage(artworkView)
  end

  def buttonsView
    @buttonsView ||= ButtonsView.alloc.init
  end

  def trackDetailsView
    @trackDetailsView ||= TrackDetailsView.alloc.init
  end

  def build_views
    views_dictionary = {
        "artworkView" => artworkView,
        "trackDetailsView" => trackDetailsView,
        "buttonsView" => buttonsView
    }

    views_dictionary.each do |key, view|
      contentView.addSubview(view)
    end

    contentView.backgroundColor = NSColor.yellowColor
    contentView.translatesAutoresizingMaskIntoConstraints = false

    constraints = []
    constraints += NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[artworkView(==75)][trackDetailsView]-[buttonsView]|",
      options:NSLayoutFormatAlignAllCenterY,
      metrics:nil,
      views:views_dictionary
    )
    constraints += NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[artworkView(==75)]|",
      options:NSLayoutFormatAlignAllCenterX,
      metrics:nil,
      views:views_dictionary
    )
    constraints += NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[trackDetailsView]|",
      options:NSLayoutFormatAlignAllCenterX,
      metrics:nil,
      views:views_dictionary
    )
    constraints += NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[buttonsView]|",
      options:NSLayoutFormatAlignAllCenterX,
      metrics:nil,
      views:views_dictionary
    )
    contentView.addConstraints(constraints)
  end

end


