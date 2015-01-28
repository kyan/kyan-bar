class VoteHandler

  attr_reader :vote

  def initialize(vote)
    @vote = vote
  end

  def self.register(vote)
    vote_handler = new(vote)
    vote_handler.register
  end

  def register
    if valid?
      AFMotion::HTTP.get(vote_url) do |response|
        if response.body.to_s.include?('login details incorrect')
          alert_creds_wrong
        else
          response.success?
        end
      end
    else
      alert_no_creds
      false
    end
  end

  private

  def vote_url
    "#{VOTE_URL}vote[aye]=#{vote}&login[user]=#{username}&login[password]=#{password}"
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

end