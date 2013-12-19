class JukeboxControlWindow < NSWindow

  attr_reader :nowplaying_controller

  def self.build
    alloc.initWithContentRect([[50, 50], [100, 60]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: true
    ).tap do |win|
      win.build_views
    end
  end

  def register_vote(button)
    if VoteHandler.register(button.vote)
      puts "#{button.vote} vote registered"
    else
      puts "vote registerinf failed!"
    end
  end

  def build_views
    @nowplaying_controller = NowplayingController.new
    @vote_buttons = VoteButtonsView.new

    views_dictionary = {
      "now_playing"  => @nowplaying_controller.view,
      "vote_buttons" => @vote_buttons
    }

    metrics_dict = {
      "max_width"   => 450,
      "min_width"   => 300
    }

    views_dictionary.each do |key, view|
      contentView.addSubview(view)
    end

    constraints = []
    constraints += NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-5-[now_playing]-5-|",
      options:0,
      metrics:nil,
      views:views_dictionary
    )
    constraints += NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-5-[vote_buttons]-5-|",
      options:0,
      metrics:nil,
      views:views_dictionary
    )
    constraints += NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[now_playing(>=min_width,<=max_width)]-5-[vote_buttons]-10-|",
      options:0,
      metrics:metrics_dict,
      views:views_dictionary
    )
    contentView.addConstraints(constraints)
  end

end


