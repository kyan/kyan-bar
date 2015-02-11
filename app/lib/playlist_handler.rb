class PlaylistHandler

  attr_reader :data_as_json

  def initialize(track)
    @data_as_json = BW::JSON.generate({'filenames' => [track]})
  end

  def self.add!(track)
    handler = new(track)
    handler.add
  end

  def add
    if valid?
      AFMotion::HTTP.get(dest_url) do |response|
        if response.body.to_s.include?('login details incorrect')
          alert_creds_wrong
        else
          if response.success?
            parse_json(response.body)
            do_notification
          end
        end
      end
    else
      alert_no_creds
      false
    end
  end

  private

  def dest_url
    json_encode = data_as_json.to_url_encoded
    encoded_str = "user=#{username}&password=#{password}&argument=#{json_encode}"
    "#{JUKEBOX_URL}/run/bulk_add_to_playlist?#{encoded_str}"
  end

  def valid?
    username && password
  end

  def username
    Persistence.get("jukeboxUsername")
  end

  def password
    Persistence.get("jukeboxPassword")
  end

  def alert_creds_wrong
    oops(
      'Doh?',
      'Your jukebox username or password appear to be wrong!'
    )
  end

  def alert_no_creds
    oops(
      'Want to vote huh?',
      'You need to set your username and password in preferences'
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

  def parse_json(str)
    e = Pointer.new(:object)
    json = NSJSONSerialization.JSONObjectWithData( String(str).to_data,
      options:0,
      error: e
    )
    @track = json.first
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