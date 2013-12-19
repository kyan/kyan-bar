class VoteButtonsView < NSView

  def init
    super.tap do |v|
      views_dictionary = {
          "up_vote_button" => up_vote_button,
          "down_vote_button" => down_vote_button
      }
      views_dictionary.each do |key, view|
        v.addSubview(view)
      end
      v.translatesAutoresizingMaskIntoConstraints = false
      constraints = []
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|[up_vote_button(==35)]|",
        options:0,
        metrics:nil,
        views:views_dictionary
      )
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|[down_vote_button(==35)]|",
        options:0,
        metrics:nil,
        views:views_dictionary
      )
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|[up_vote_button]-4-[down_vote_button]|",
        options:NSLayoutFormatAlignAllCenterX,
        metrics:nil,
        views:views_dictionary
      )
      v.addConstraints constraints
    end
  end

  def up_vote_button
    @up_vote_button ||= VoteButton.alloc.initWithVote(true)
  end

  def down_vote_button
    @down_vote_button ||= VoteButton.alloc.initWithVote(false)
  end

end