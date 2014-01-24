class VoteMetricsView < NSView

  attr_accessor :rating

  def init
    super.tap do |v|
      v.translatesAutoresizingMaskIntoConstraints = false

      @vote_txt_holder ||= draw_vote_txt_holder

      views_dictionary = {
        "up_vote_button" => @vote_txt_holder
      }

      metrics_dict = {
        "padding" => 10
      }

      views_dictionary.each do |key, view|
        v.addSubview(view)
      end

      constraints = []
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|[up_vote_button]|",
        options:0,
        metrics:metrics_dict,
        views:views_dictionary
      )
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|[up_vote_button]-(<=padding)-|",
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

    txt = no_votes? ? no_vote_txt : draw_vote_txt
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
    end
  end

  def draw_vote_txt
    draw_uvotes + '  '.attrd + draw_dvotes
  end

  def draw_uvotes
    if rating.positive_ratings.empty?
      ''.attrd
    else
      "▲".attrd({
        'NSFont' => NSFont.fontWithName("Lucida Grande", size:12),
        'NSColor' => NSColor.greenColor
      }) +
      " #{rating.positive_ratings.join(', ')}".attrd({
        'NSFont' => NSFont.fontWithName("Lucida Grande", size:10),
        'NSColor' => NSColor.darkGrayColor
      })
    end
  end

  def draw_dvotes
    if rating.negative_ratings.empty?
      ''.attrd
    else
      "▼".attrd({
        'NSFont' => NSFont.fontWithName("Lucida Grande", size:12),
        'NSColor' => NSColor.redColor
      }) +
      " #{rating.negative_ratings.join(', ')}".attrd({
        'NSFont' => NSFont.fontWithName("Lucida Grande", size:10),
        'NSColor' => NSColor.darkGrayColor
      })
    end
  end

  def no_vote_txt
    "No votes".attrd({
      'NSFont' => NSFont.fontWithName("Lucida Grande", size:10),
      'NSColor' => NSColor.grayColor
    })
  end

  def no_votes?
    return true if rating.nil?
    rating.positive_ratings.empty? && rating.negative_ratings.empty?
  end
end