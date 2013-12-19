class VoteButton < NSButton

  attr_reader :vote

  def initWithVote vote
    init.tap do |button|
      @vote = vote
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setBezelStyle(NSTexturedSquareBezelStyle)
      button.setButtonType(NSMomentaryPushButton)

      paragraph = NSMutableParagraphStyle.new
      paragraph.setAlignment(NSCenterTextAlignment)

      txt = vote ? "Vote Up" : "Vote Down"
      txt = txt.attrd({
        'NSFont' => NSFont.fontWithName("Lucida Grande", size:10),
        'NSParagraphStyle' => paragraph
      })

      button.setAttributedTitle(txt)
      button.setAction "register_vote:"
    end
  end

end