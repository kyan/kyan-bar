class VoteButtonsView < NSView

  attr_reader :up_vote_button, :down_vote_button

  def init
    super.tap do |v|
      v.translatesAutoresizingMaskIntoConstraints = false

      views_dictionary = {
        "up_vote_button" => up_vote_button,
        "down_vote_button" => down_vote_button
      }

      metrics_dict = {
        "butt_w" => 50,
        "butt_h" => 22,
        "butt_space" => 5,
      }

      views_dictionary.each do |key, view|
        v.addSubview(view)
      end

      constraints = []
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|[up_vote_button(==butt_w)]|",
        options:0,
        metrics:metrics_dict,
        views:views_dictionary
      )
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|[down_vote_button(==butt_w)]|",
        options:0,
        metrics:metrics_dict,
        views:views_dictionary
      )
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|-butt_space-[up_vote_button(==butt_h)]",
        options:NSLayoutFormatAlignAllRight,
        metrics:metrics_dict,
        views:views_dictionary
      )
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "V:[down_vote_button(==butt_h)]-butt_space-|",
        options:NSLayoutFormatAlignAllRight,
        metrics:metrics_dict,
        views:views_dictionary
      )

      v.addConstraints constraints
    end
  end

  def up_vote_button
    @up_vote_button ||= VoteButton.alloc.initWithVote(true)
    @up_vote_button.tag = U_VOTE_BUTTON
    @up_vote_button
  end

  def down_vote_button
    @down_vote_button ||= VoteButton.alloc.initWithVote(false)
    @down_vote_button.tag = D_VOTE_BUTTON
    @down_vote_button
  end

end