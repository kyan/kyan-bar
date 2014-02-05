class ProgressView < NSView

  attr_accessor :time, :duration

  def init
    super.tap do |v|
      v.translatesAutoresizingMaskIntoConstraints = false

      @time = 0.0
      @duration = 0.0
      @timer = NSTimer.scheduledTimerWithTimeInterval(
        1.0,
        target:self,
        selector:'increment_timer',
        userInfo:nil,
        repeats: true
      )
    end
  end

  def refresh!(track, time)
    self.duration = duration_to_seconds(track.duration)
    self.time = time.to_f
    setNeedsDisplay(true)
  end

  def tag
    PROGRESS_VIEW
  end

  def drawRect(dirtyRect)
    NSColor.lightGrayColor.setFill
    NSRectFill(dirtyRect)

    path = NSBezierPath.bezierPath
    path.moveToPoint([0,0])
    path.lineToPoint([progress,0])
    NSColor.darkGrayColor.setStroke
    path.stroke

    super dirtyRect
  end

  private

  def increment_timer
    self.time += 1.0
    setNeedsDisplay(true)
  end

  def progress_percent
    if time < duration
      (time / duration * 100).to_i
    else
      0
    end
  end

  def progress
    (progress_percent * (frame.size.width/100.0)).to_i
  end

  #
  # We shouldn't have to do this. Convert e.g 5:23 into seconds
  #
  def duration_to_seconds(str)
    return 0.0 if str.nil?
    m,s = str.split(":")
    ((m.to_i * 60) + s.to_i).to_f
  end

end