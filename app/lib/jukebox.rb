module JukeBox
  class Notify

    #  :state, :time, :rating, :track_added, :track, :playlist, :volume
    VALID_KEYS = [ :track ]

    def initialize(payload)
      @payload = WeakRef.new(payload)
      @data    = parse_payload
    end

    def track
      return nil if  @data['track'].nil?
      @track ||= Track.build @data['track']
    end

    def rating
      return nil if  @data['rating'].nil?
      @rating ||= Rating.build @data['rating']
    end

    def notifications
      VALID_KEYS.map {|k| send(k) if respond_to?(k)}.compact
    end

    private

    def parse_payload
      begin
        BW::JSON.parse(@payload.dataUsingEncoding(NSUTF8StringEncoding))
      rescue BubbleWrap::JSON::ParserError
      end
    end
  end

  class Rating
    attr_accessor :positive_ratings, :rating_class, :negative_ratings,
                  :file, :rating

    def initialize(data)
      @data = data

      @data.each do |k,v|
        if respond_to?(k.to_sym)
          send("#{k}=", v)
        end
      end
    end

    def heading
      "Rating"
    end

    def subtitle
      "Current: #{rating}"
    end

    def description
      pos = positive_ratings.empty? ? '...' : positive_ratings.join(', ')
      neg = negative_ratings.empty? ? '...' : negative_ratings.join(', ')

      "Up: #{pos} - Down: #{neg}"
    end

    def valid?
      self
    end

    def self.build(hsh)
      return {} if hsh.nil?
      new(hsh)
    end
  end

  class Track
    attr_accessor :title, :artist, :album, :added_by,
                  :dbid, :rating, :file, :duration,
                  :artwork_url, :rating_class

    def initialize(data)
      @data = data

      @data.each do |k,v|
        if respond_to?(k.to_sym)
          send("#{k}=", v)
        end
      end
    end

    def heading
      title
    end

    def subtitle
      artist
    end

    def description
      [album, duration].compact.join(' - ')
    end

    def self.build(hsh)
      return {} if hsh.nil?
      new(hsh)
    end
  end
end