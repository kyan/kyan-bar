class UpcomingController < NSViewController

  def init
    super.tap do |c|
      c.init_data
      c.build_view

      @update_observer = App.notification_center.observe JB_UPDATED do |n|
        refresh(n.userInfo[:jukebox])
      end
    end
  end

  def refresh(jukebox)
    @jukebox = jukebox
    refresh_tracks
    @table_view.reloadData
  end

  def init_data
    @upcoming_tracks = []
  end

  def build_view
    @table_view = UpcomingTableView.alloc.init
    @table_view.setBoundsOrigin([-10,0]);
    @table_view.setBoundsSize([@table_view.bounds.size.width+20, @table_view.bounds.size.height]);
    @table_view.delegate = self
    @table_view.dataSource = self
    self.setView(@table_view)
  end

  def numberOfRowsInTableView(table_view)
    @upcoming_tracks.count
  end

  def tableView(table_view, objectValueForTableColumn:table_column, row:row)
    case table_column.identifier.to_sym
    when :thumb
      if @upcoming_tracks[row].artwork_url.nil?
        NSImage.imageNamed("missing_artwork.png")
      else
        url = NSURL.URLWithString(@upcoming_tracks[row].artwork_url)
        NSImage.alloc.initWithContentsOfURL(url)
      end
    when :title
      str = "#{@upcoming_tracks[row].heading} (#{@upcoming_tracks[row].added_by})"
      paragraph = NSMutableParagraphStyle.new
      paragraph.setLineBreakMode(NSLineBreakByTruncatingTail)

      str.attrd({
        'NSParagraphStyle' => paragraph
      })
    when :duration
      @upcoming_tracks[row].eta
    end
  end

  def tableView(table_view, heightOfRow:row)
    20
  end

  def tableView(table_view, viewForTableColumn:table_column, row:row)
    tview = table_view.makeViewWithIdentifier(table_column.identifier, owner:self)

    case table_column.identifier.to_sym
    when :thumb
      tview = NSImageView.new.tap do |v|
        v.setTranslatesAutoresizingMaskIntoConstraints(false)
        v.setEditable(false)
        v.setImageScaling(NSImageScaleAxesIndependently)
        v.identifier = 'thumbid'
      end
    when :title
      tview = NSTextField.new.tap do |v|
        v.frame = CGRectZero
        v.font = NSFont.systemFontOfSize(12.0)
        v.setEditable(false)
        v.setBezeled(false)
        v.setDrawsBackground(false)
        v.setSelectable(false)
        v.identifier = 'titleid'
      end
    else
      tview = NSTextField.new.tap do |v|
        v.frame = CGRectZero
        v.setEditable(false)
        v.setBezeled(false)
        v.setAlignment(NSRightTextAlignment)
        v.setDrawsBackground(false)
        v.setSelectable(false)
        v.identifier = 'defaultid'
      end
    end

    tview
  end

  private

  def refresh_tracks
    @upcoming_tracks = @jukebox.playlist.upcoming_tracks(current_track)[0...5]
  end

  def current_track
    return @jukebox.track.file if @jukebox.last_change?(:track)
    nil
  end
end
