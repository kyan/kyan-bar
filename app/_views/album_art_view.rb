class AlbumArtView < NSImageView

  def init
    super.tap do |v|
      v.setTranslatesAutoresizingMaskIntoConstraints(false)
      v.setEditable(false)
      v.setImageScaling(NSImageScaleAxesIndependently)

      @vote_view = VoteView.new
      v.addSubview(@vote_view)

      @vote_slider_in_progress = false
      @vote_toggle_state_active = always_show_votes?
      slidein_vote_view

      @update_observer = App.notification_center.observe JB_TOGGLE_VOTE_SLIDER do |n|
        state = n.userInfo[:state]
        @vote_toggle_state_active = state
        handle_vote_toggle_update
      end
    end
  end

  def handle_vote_toggle_update
    vote_toggle_state_active? ? slidein_vote_view : slideout_vote_view
  end

  def slidein_vote_view
    return if vote_slider_in_progress?

    new_frame = @vote_view.frame
    new_frame.origin.x = 0

    @vote_slider_in_progress = true

    NSAnimationContext.beginGrouping
    NSAnimationContext.currentContext.setCompletionHandler(
      lambda do
        if !vote_toggle_state_active?
          timer = NSTimer.scheduledTimerWithTimeInterval(
            5.0,
            target:self,
            selector:'slideout_vote_view',
            userInfo:nil,
            repeats: false
          )
          NSRunLoop.mainRunLoop.addTimer(timer, forMode:NSRunLoopCommonModes)
        end
      end
    )
    NSAnimationContext.currentContext.setDuration(0.5)
    @vote_view.animator.setFrame(new_frame)
    NSAnimationContext.endGrouping
  end

  def slideout_vote_view
    new_frame = @vote_view.frame
    new_frame.origin.x = -VOTE_VIEW_W

    NSAnimationContext.beginGrouping
    NSAnimationContext.currentContext.setCompletionHandler(
      lambda do
        @vote_slider_in_progress = false
        slidein_vote_view if vote_toggle_state_active?
      end
    )
    NSAnimationContext.currentContext.setDuration(0.5)
    @vote_view.animator.setFrame(new_frame)
    NSAnimationContext.endGrouping
  end

  def handle_vote(score, rating)
    @vote_view.do_vote(score, rating)
    make_turd if !score.nil? && score < -6

    slidein_vote_view
  end

  def drawRect(dirtyRect)
    super dirtyRect

    @vote_view.removeFromSuperview
    addSubview(@vote_view, positioned:NSWindowAbove, relativeTo:nil)

    NSColor.grayColor.set

    path = NSBezierPath.bezierPath
    path.appendBezierPathWithRect([[0,0],[50,50]])
    path.setLineWidth(1.0)
    path.stroke
  end

  def mouseEntered(event)
    slidein_vote_view
  end

  def updateTrackingAreas
    if @trackingArea != nil
      removeTrackingArea(@trackingArea)
    end

    @trackingArea = NSTrackingArea.alloc.initWithRect(
      [[0,frame.size.height-VOTE_VIEW_H],[VOTE_VIEW_W,frame.size.height]],
      options:NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways,
      owner:self,
      userInfo:nil
    )

    addTrackingArea(@trackingArea)
  end

  def make_turd
    turd = NSImage.imageNamed("turd.png")
    setImage(turd)
  end

  def always_show_votes?
    Persistence.get("alwaysShowVotes") == true ? 1 : 0
  end

  def vote_slider_in_progress?
    @vote_slider_in_progress
  end

  def vote_toggle_state_active?
    @vote_toggle_state_active == 1 ? true : false
  end

  def ok_to_slide_vote_in?
    !vote_slider_in_progress? && @vote_toggle_state_active
  end

  def ok_to_slide_vote_out?
    vote_slider_in_progress? && @vote_toggle_state_active
  end

end