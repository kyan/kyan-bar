class VoteView < NSView

  def init
    super.tap do |v|
      v.frame = [[0-VOTE_VIEW_W,50-VOTE_VIEW_H],[VOTE_VIEW_W,VOTE_VIEW_H]]

      @label = NSTextField.new.tap do |txt|
        txt.setEditable(false)
        txt.frame = [[3,2],[20,14]]
        txt.setSelectable(false)
        txt.setBezeled(false)
        txt.setDrawsBackground(false)
        txt.setAlignment(NSCenterTextAlignment)
      end

      v.addSubview(@label)
    end
  end

  def do_vote(rating)
    # grey
    bg_col = NSColor.colorWithCalibratedRed(0.227, green:0.251, blue:0.337, alpha:0.8)
    fg_col = NSColor.whiteColor

    if rating.nil?
      rating = "#"
      # lightgrey
      bg_col = NSColor.colorWithCalibratedRed(0.7, green:0.7, blue:0.7, alpha:0.8)
      fg_col = NSColor.whiteColor
    else
      # green
      if rating > 0
        bg_col = NSColor.colorWithCalibratedRed(0, green:0.93, blue:0, alpha:0.8)
        fg_col = NSColor.blackColor
      end

      # red
      if rating < 0
        bg_col = NSColor.colorWithCalibratedRed(0.9, green:0.4, blue:0.3, alpha:0.8)
        fg_col = NSColor.blackColor
      end
    end

    txt = rating.to_s.attrd({
      'NSFont' => NSFont.fontWithName("Helvetica Bold", size:10),
      'NSColor' => fg_col
    })
    @label.setAttributedStringValue(txt)
    @bg_color = bg_col
  end

  def drawRect(dirtyRect)
    draw_backing if @bg_color

    super dirtyRect
  end

  def draw_backing
      radius = 15.0

      path = NSBezierPath.bezierPath
      path.moveToPoint([0,0])
      path.lineToPoint([VOTE_VIEW_W-radius,0])
      path.curveToPoint([VOTE_VIEW_W,0+radius], controlPoint1:[VOTE_VIEW_W,0], controlPoint2:[VOTE_VIEW_W,0])
      path.lineToPoint([VOTE_VIEW_W,VOTE_VIEW_H])
      path.lineToPoint([0,VOTE_VIEW_H])
      path.lineToPoint([0,0])
      @bg_color.setFill
      path.fill
  end
end