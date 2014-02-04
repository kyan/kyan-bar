class UpcomingView < NSView

  attr_accessor :table

  def initWithFrame(frame)
    super(frame).tap do |cell|
      cell.translatesAutoresizingMaskIntoConstraints = false

      @table    ||= draw_table

      views_dict = {
        "table"   => @table
      }

      metrics_dict = {
        "h_spacing"    => 5,
        "h_padding"    => 10,
        "v_padding"    => 10
      }

      views_dict.each do |key, view|
        cell.addSubview(view)
      end

      constraints = []
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|[table]|",
        options:NSLayoutFormatAlignAllLeft,
        metrics:metrics_dict,
        views:views_dict
      )
      constraints += NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|[table]|",
        options:0,
        metrics:metrics_dict,
        views:views_dict
      )
      cell.addConstraints(constraints)
    end
  end

  def refresh(jukebox)
    @jukebox = jukebox
    update_data!
  end

  def track
    @jukebox.track unless @jukebox.nil?
  end

  def rating
    @jukebox.rating unless @jukebox.nil?
  end

  private

  def valid_jb_data?(key)
    @jukebox.whats_changed.include?(key)
  end

  def should_update?
    valid_jb_data?(:track) || valid_jb_data?(:rating)
  end

  def update_data!
    if @jukebox && should_update?
      update_table
    end

    invalidateIntrinsicContentSize
    setNeedsDisplay(true)
  end

  def draw_table
    NSTableView.new
  end

  def update_table
  end

end