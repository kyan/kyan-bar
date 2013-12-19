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
      BW::HTTP.get(vote_url) do |response|
        response.ok?
      end
    else
      oops
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

  def oops
    alert = NSAlert.new
    alert.messageText = 'Want to vote huh?'
    alert.informativeText = 'You need to set your username and password in preferences'
    alert.alertStyle = NSInformationalAlertStyle
    alert.addButtonWithTitle("Ok")
    response = alert.runModal
  end

end