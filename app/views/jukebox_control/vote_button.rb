class VoteButton < NSButton

  attr_reader :vote

  def initWithVote vote
    init.tap do |button|
      @vote = vote
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setTitle vote ? "+" : "-"
      button.setAction "registerVote:"
    end
  end

end