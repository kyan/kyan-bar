class JukeboxControlWindow < NSWindow

  attr_reader :nowplaying_controller

  def self.build
    alloc.initWithContentRect([[50, 50], [100, 60]],
      styleMask: NSBorderlessWindowMask|NSTexturedBackgroundWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: true
    ).tap do |win|
      win.setFrameAutosaveName("MAINWINDOWPositionHeightWidth")
      win.build_views
    end
  end

  def canBecomeKeyWindow
    true
  end

  def canBecomeMainWindow
    true
  end

  def register_vote(button)
    VoteHandler.register(button.vote)
  end

  def build_views
    @nowplaying_controller = NowplayingController.new
    @vote_buttons = VoteButtonsView.new
    @vote_metrics = VoteMetricsView.new

    views_dictionary = {
      "now_playing"  => @nowplaying_controller.view,
      "vote_buttons" => @vote_buttons,
      "vote_metrics" => @vote_metrics
    }

    metrics_dict = {
      "padding"       => 10,
      "default_width" => 200,
      "max_width"     => 350,
      "buttons_h_min" => 30,
      "buttons_h_max" => 80
    }

    views_dictionary.each do |key, view|
      contentView.addSubview(view)
    end

    constraints = []
    constraints += NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-5-[now_playing]-5-[vote_metrics]|",
      options:0,
      metrics:metrics_dict,
      views:views_dictionary
    )
    constraints += NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-5-[vote_buttons]-5-[vote_metrics]|",
      options:0,
      metrics:metrics_dict,
      views:views_dictionary
    )
    constraints += NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[now_playing(>=default_width,<=max_width)]-5-[vote_buttons]-padding-|",
      options:0,
      metrics:metrics_dict,
      views:views_dictionary
    )
    constraints += NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-padding-[vote_metrics]-padding-|",
      options:0,
      metrics:metrics_dict,
      views:views_dictionary
    )
    contentView.addConstraints(constraints)
  end

end


