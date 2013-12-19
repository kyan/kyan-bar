class VoteHandler

  attr_reader :vote

  def initialize vote
    @vote = vote
  end

  def self.register vote
    vote_handler = new(vote)
    vote_handler.register
  end

  def register
    BW::HTTP.get(vote_url) do |response|
      #puts response.body.to_str
    end
  end

  private

  def vote_url
    "#{VOTE_URL}login[user]=#{username}&login[password]=#{password}"
  end

  def username
    Persistence.get("jukeboxUsername")
  end

  def password
    Persistence.get("jukeboxPassword")
  end

end