class PlaylistHandler

  attr_reader :track

  def initialize(track)
    @track = track
  end

  def self.add!(track)
    handler = new(track)
    handler.add
  end

  def add
    # '{"user_id":99,"bulk_add_to_playlist":"{\"filenames\":[\"spotify:track:6AwunqOdRD8wDgqzORe9Le\"]}"}'
    if valid?
      payload = BW::JSON.generate({
        user_id: Persistence.uid,
        bulk_add_to_playlist: {
          filenames: [track.gsub(/^.*\/track\//,'spotify:track:')]
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

  def do_notification
    track = KyanJukebox::Track.new
    track.title = 'Successfully added to Jukebox'
    track.artist = "#{@track["title"]} - #{@track["artist"]}"
    track.album = @track["album"]
    track.artwork_url = @track["artwork_url"]

    KyanBar::Notifier.send!([track])
  end

end