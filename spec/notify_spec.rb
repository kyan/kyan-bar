describe "Jukebox Notifications" do
  before do
    data = open('spec/fixtures/sample.json').read
    @notify = JukeBox::Notify.new(data)
  end

  context "A Jukebox" do
    it "Has notifications" do
      @notify.notifications.should.not.be.empty
      puts @notify.notifications.map(&:description)
    end
  end

  context "A Track" do
    it "has a track" do
      @notify.track.title.should == "Ernest Borgnine"
    end

    it "has an artist" do
      @notify.track.artist.should == "John Grant"
    end

    it "has an added_by" do
      @notify.track.added_by.should == "Gav"
    end

    it "has a file" do
      @notify.track.file.should == "gavin/John Grant/Pale Green Ghosts/09 Ernest Borgnine.mp3"
    end

    it "has a rating" do
      @notify.track.rating.should == 1
    end

    it "has a dbid" do
      @notify.track.dbid.should == 29404
    end

    it "has a duration" do
      @notify.track.duration.should == '04:53'
    end

    it "has an album" do
      @notify.track.album.should == 'Pale Green Ghosts'
    end

    it "has artwork_url" do
      @notify.track.artwork_url.should == 'http://ecx.images-amazon.com/images/I/51OTk9vdQML.jpg'
    end

    it "has rating_class" do
      @notify.track.rating_class.should == 'positive_1'
    end
  end

  context "A Rating" do
    it "has a positive_ratings" do
      @notify.rating.positive_ratings.should == ["Gav"]
    end

    it "has an rating_class" do
      @notify.rating.rating_class.should == "positive_1"
    end

    it "has an negative_ratings" do
      @notify.rating.negative_ratings.should == []
    end

    it "has an file" do
      @notify.rating.file.should == "gavin/John Grant/Pale Green Ghosts/09 Ernest Borgnine.mp3"
    end

    it "has an rating" do
      @notify.rating.rating.should == 1
    end
  end
end