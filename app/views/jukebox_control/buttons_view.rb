class ButtonsView < NSView

  def init
    super.tap do |buttonsView|
      views_dictionary = {
          "upVoteButton" => upVoteButton,
          "downVoteButton" => downVoteButton
      }
      views_dictionary.each do |key, view|
        buttonsView.addSubview(view)
      end
      buttonsView.translatesAutoresizingMaskIntoConstraints = false
      constraints = []
      constraints += NSLayoutConstraint.constraintsWithVisualFormat "H:|[upVoteButton(==30)]|",
                                                                options:NSLayoutFormatAlignAllCenterY,
                                                                metrics:nil,
                                                                views:views_dictionary
      constraints += NSLayoutConstraint.constraintsWithVisualFormat "H:|[downVoteButton(==30)]|",
                                                                options:NSLayoutFormatAlignAllCenterY,
                                                                metrics:nil,
                                                                views:views_dictionary

      constraints += NSLayoutConstraint.constraintsWithVisualFormat "V:|[upVoteButton(==30)]-[downVoteButton(==30)]",
                                                              options:NSLayoutFormatAlignAllCenterX,
                                                              metrics:nil,
                                                              views:views_dictionary
      buttonsView.addConstraints constraints
    end
  end

  def upVoteButton
    @upVoteButton ||= VoteButton.alloc.initWithVote(true)
  end

  def downVoteButton
    @downVoteButton ||= VoteButton.alloc.initWithVote(false)
  end

end