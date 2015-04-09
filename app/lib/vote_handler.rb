class VoteHandler

  attr_reader :vote, :track

  def initialize(vote, track)
    @vote = vote
    @track = track
  end

  def self.register(vote, track)
    vote_handler = new(vote, track)
    vote_handler.register
  end

  def register
    if valid?
      payload = BW::JSON.generate({
        user_id: Persistence.uid,
        vote: {
          state: (vote ? 1 : 0),
          filename: track.file
        }
      })
      WebsocketConnector.instance.websocket.send(payload)
    else
      alert_no_creds
      false
    end
  end

  private

  def valid?
    uid = Persistence.uid
    uid && uid.to_i != 0
  end

  def alert_no_creds
    oops(
      'Want to vote huh?',
      'You need to set your User ID in preferences'
    )
  end

  def oops(title, message)
    alert = NSAlert.new
    alert.messageText = title
    alert.informativeText = message
    alert.alertStyle = NSInformationalAlertStyle
    alert.addButtonWithTitle("Ok")
    response = alert.runModal
  end

end