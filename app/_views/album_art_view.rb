class AlbumArtView < NSImageView

  def init
    super.tap do |v|
      v.setTranslatesAutoresizingMaskIntoConstraints(false)
      v.setEditable(false)
      v.setImageScaling(NSImageScaleAxesIndependently)

      @vote_view = VoteView.new
      v.addSubview(@vote_view)

      @vote_slider_in_progress = false

      slidein_vote_view
    end
  end

  def slidein_vote_view
    return if @vote_slider_in_progress

    new_frame = @vote_view.frame
    new_frame.origin.x += VOTE_VIEW_W

    @vote_slider_in_progress = true
    NSAnimationContext.beginGrouping
    NSAnimationContext.currentContext.setCompletionHandler(
      lambda do
        timer = NSTimer.scheduledTimerWithTimeInterval(
          5.0,
          target:self,
          selector:'slideout_vote_view',
          userInfo:nil,
          repeats: false
        )
        NSRunLoop.mainRunLoop.addTimer(timer, forMode:NSRunLoopCommonModes)
      end
    )
    NSAnimationContext.currentContext.setDuration(0.5)
    @vote_view.animator.setFrame(new_frame)
    NSAnimationContext.endGrouping
  end

  def slideout_vote_view
    new_frame = @vote_view.frame
    new_frame.origin.x -= VOTE_VIEW_W

    NSAnimationContext.beginGrouping
    NSAnimationContext.currentContext.setCompletionHandler(
      lambda do
        @vote_slider_in_progress = false
      end
    )
    NSAnimationContext.currentContext.setDuration(0.5)
    @vote_view.animator.setFrame(new_frame)
    NSAnimationContext.endGrouping
  end

  def handle_vote(score, rating)
    @vote_view.do_vote(score, rating)
    slidein_vote_view
  end

  def drawRect(dirtyRect)
    super dirtyRect

    @vote_view.removeFromSuperview
    addSubview(@vote_view, positioned:NSWindowAbove, relativeTo:nil)
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

end