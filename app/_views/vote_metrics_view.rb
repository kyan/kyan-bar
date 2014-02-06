class VoteMetricsView < NSView

  attr_accessor :rating

  def init
    super.tap do |v|
      v.translatesAutoresizingMaskIntoConstraints = false

      @vote_txt_holder ||= draw_vote_txt_holder

      views_dictionary = {
        "vote_txt_holder" => @vote_txt_holder
      }

      metrics_dict = {
        "padding" => 5
      }

      views_dictionary.each do |key, view|
        v.addSubview(view)
      end

      constraints = []
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|[vote_txt_holder]|",
        options:0,
        metrics:metrics_dict,
        views:views_dictionary
      )
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|[vote_txt_holder]-(<=padding)-|",
        options:NSLayoutFormatAlignAllRight,
        metrics:metrics_dict,
        views:views_dictionary
      )

      v.addConstraints constraints
    end
  end

  def refresh!(rating)
    self.rating = rating
    update_vote_txt
  end

  def tag
    VOTE_TXT_VIEW
  end

  private

  def update_vote_txt
    paragraph = NSMutableParagraphStyle.new
    paragraph.setLineBreakMode(NSLineBreakByTruncatingTail)

    txt = if no_votes?
      App.shared.delegate.update_status_bar_icon(true)
      no_vote_txt
    else
      App.shared.delegate.update_status_bar_icon(false)
      draw_vote_txt
    end

    @vote_txt_holder.setAttributedStringValue(txt)
    @vote_txt_holder.setToolTip(rating.description) unless rating.nil?
  end

  def draw_vote_txt_holder
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
      v.setFont(NSFont.systemFontOfSize(10))
    end
  end

  def draw_vote_txt
    draw_uvotes + '  '.attrd + draw_dvotes
  end

  def draw_uvotes
    if blank?(rating.positive_ratings)
      ''.attrd
    else
      "▲".attrd({
        'NSColor' => NSColor.greenColor
      }) +
      " #{rating.positive_ratings.join(', ')}".attrd({
        'NSColor' => NSColor.darkGrayColor
      })
    end
  end

  def draw_dvotes
    if blank?(rating.negative_ratings)
      ''.attrd
    else
      "▼".attrd({
        'NSColor' => NSColor.redColor
      }) +
      " #{rating.negative_ratings.join(', ')}".attrd({
        'NSColor' => NSColor.darkGrayColor
      })
    end
  end

  def no_vote_txt
    "No votes".attrd({
      'NSColor' => NSColor.grayColor
    })
  end

  def no_votes?
    return true if rating.nil?
    blank?(rating.positive_ratings) && blank?(rating.negative_ratings)
  end

  def blank?(str)
    str.respond_to?(:empty?) ? str.empty? : !str
  end
end