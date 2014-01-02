class VoteButton < NSButton

  attr_reader :vote

  def initWithVote vote
    init.tap do |button|
      @vote = vote
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setBezelStyle(NSTexturedSquareBezelStyle)
      button.setButtonType(NSMomentaryPushButton)
      button.setAction "register_vote:"

      if vote
        button.cell.setImage(NSImage.imageNamed(NSImageNameAddTemplate))
        button.setToolTip(" Vote Up ")
      else
        button.cell.setImage(NSImage.imageNamed(NSImageNameRemoveTemplate))
        button.setToolTip(" Vote Down ")
      end
    end
  end

end