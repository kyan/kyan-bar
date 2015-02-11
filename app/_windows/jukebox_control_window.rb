class JukeboxControlWindow < NSWindow

  attr_reader :nowplaying_controller

  def self.build
    alloc.initWithContentRect([[50, 50], [100, 50]],
      styleMask: NSBorderlessWindowMask|NSTexturedBackgroundWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: true
    ).tap do |win|
      win.setFrameAutosaveName("MAINWINDOWPositionHeightWidth")
      win.build_views

      win.registerForDraggedTypes([NSPasteboardTypeString])
    end
  end

  def draggingEntered(sender)
    source_drag_mask = sender.draggingSourceOperationMask
    pboard = sender.draggingPasteboard

    if pboard.types.include?(NSPasteboardTypeString)
      if source_drag_mask & NSDragOperationGeneric
        return NSDragOperationGeneric
      end
    end

    NSDragOperationNone
  end

  def draggingUpdated(sender)
    NSDragOperationCopy
  end

  def performDragOperation(sender)
    source_drag_mask = sender.draggingSourceOperationMask
    pboard = sender.draggingPasteboard

    if pboard.types.include?(NSPasteboardTypeString)
      str = pboard.stringForType(NSPasteboardTypeString)

      # only handle tracks at the moment
      # e.g http://open.spotify.com/track/75clRtmtXSkZsPm6SjjQ5j
      if str.match(/http:\/\/open\.spotify\.com\/track\/[a-zA-Z0-9]*/)
        PlaylistHandler.add!(str)
      end
    end

    true
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
    @progress_view = ProgressView.new

    views_dictionary = {
      "now_playing"  => @nowplaying_controller.view,
      "vote_buttons" => @vote_buttons,
      "vote_metrics" => @vote_metrics,
      "progress"     => @progress_view
    }

    metrics_dict = {
      "padding"             => GLOBAL_H_PADDING,
      "padding_t"           => 4,
      "padding_t_vote_btn"  => 10,
      "padding_small"       => 4,
      "padding_vsmall"      => 4,
      "default_width"       => 200,
      "max_width"           => 350,
      "progress_h"          => 1
    }

    views_dictionary.each do |key, view|
      contentView.addSubview(view)
    end

    constraints = []
    constraints += NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-padding_t-[now_playing]-padding_small-[progress(progress_h)]-padding_vsmall-[vote_metrics]|",
      options:0,
      metrics:metrics_dict,
      views:views_dictionary
    )
    constraints += NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-padding_t_vote_btn-[vote_buttons]-padding_small-[progress(progress_h)]-padding_vsmall-[vote_metrics]|",
      options:0,
      metrics:metrics_dict,
      views:views_dictionary
    )
    constraints += NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[now_playing(>=default_width,<=max_width)]-[vote_buttons]|",
      options:0,
      metrics:metrics_dict,
      views:views_dictionary
    )
    constraints += NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-padding-[progress]-padding-|",
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


