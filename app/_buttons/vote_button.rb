class VoteButton < NSButton

  attr_reader :vote

  def initWithVote vote
    init.tap do |button|
      @vote = vote
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setBezelStyle(NSRegularSquareBezelStyle)
      button.setButtonType(NSMomentaryPushButton)
      button.setTitle vote ? "+" : "-"
      button.setAction "register_vote:"
    end
  end

end