class TrackDetailsView < NSView

  def init
    super.tap do |trackDetailsView|
      views_dictionary = {
          "artistTitleView" => artistTitleView,
          "albumView" => albumView,
          "positiveRatingsView" => positiveRatingsView,
          "negativeRatingsView" => negativeRatingsView
      }
      views_dictionary.each do |key, view|
        trackDetailsView.addSubview(view)
      end
      trackDetailsView.translatesAutoresizingMaskIntoConstraints = false
      constraints = []
      constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[artistTitleView(>=170)]|",
                                                                options:NSLayoutFormatAlignAllCenterY,
                                                                metrics:nil,
                                                                views:views_dictionary)
      constraints += NSLayoutConstraint.constraintsWithVisualFormat "H:|[albumView]|",
                                                                options:NSLayoutFormatAlignAllCenterY,
                                                                metrics:nil,
                                                                views:views_dictionary
      constraints += NSLayoutConstraint.constraintsWithVisualFormat "H:|[positiveRatingsView]|",
                                                                options:NSLayoutFormatAlignAllCenterY,
                                                                metrics:nil,
                                                                views:views_dictionary
      constraints += NSLayoutConstraint.constraintsWithVisualFormat "H:|[negativeRatingsView]|",
                                                                options:NSLayoutFormatAlignAllCenterY,
                                                                metrics:nil,
                                                                views:views_dictionary
      constraints += NSLayoutConstraint.constraintsWithVisualFormat "V:|[artistTitleView][albumView]-[positiveRatingsView][negativeRatingsView]|",
                                                                options:NSLayoutFormatAlignAllCenterX,
                                                                metrics:nil,
                                                                views:views_dictionary
      trackDetailsView.addConstraints constraints
    end
  end

  def artistTitleView
    @artistTitleView ||= NSTextField.alloc.init.tap do |label|
      label.translatesAutoresizingMaskIntoConstraints = false
      label.editable = false
      label.selectable  = false
      label.drawsBackground = true
      label.textColor = NSColor.blackColor
      label.bordered  = false
      label.alignment = NSLeftTextAlignment
      label.backgroundColor = NSColor.clearColor
    end
  end

  def albumView
    @albumView ||= NSTextField.alloc.init.tap do |label|
      label.translatesAutoresizingMaskIntoConstraints = false
      label.editable = false
      label.selectable  = false
      label.drawsBackground = true
      label.textColor = NSColor.grayColor
      label.bordered  = false
      label.alignment = NSLeftTextAlignment
      label.backgroundColor = NSColor.clearColor
    end
  end

  def negativeRatingsView
    @negativeRatingsView ||= NSTextField.alloc.init.tap do |label|
      label.translatesAutoresizingMaskIntoConstraints = false
      label.editable = false
      label.selectable  = false
      label.drawsBackground = true
      label.textColor = NSColor.blackColor
      label.bordered  = false
      label.alignment = NSLeftTextAlignment
      label.backgroundColor = NSColor.clearColor
    end
  end

  def positiveRatingsView
    @positiveRatingsView ||= NSTextField.alloc.init.tap do |label|
      label.translatesAutoresizingMaskIntoConstraints = false
      label.editable = false
      label.selectable  = false
      label.drawsBackground = true
      label.textColor = NSColor.blackColor
      label.bordered  = false
      label.alignment = NSLeftTextAlignment
      label.backgroundColor = NSColor.clearColor
    end
  end

  def new_message message
    puts "new_message: #{message}"
    case message
    when ::KyanJukebox::Track
      puts "New Track"
      artistTitleView.stringValue = "#{message.artist} '#{message.title}'"
      albumView.stringValue = message.album
    when ::KyanJukebox::Rating
      positiveRatingsView.stringValue = "+ #{message.positive_ratings.join(", ")}"
      negativeRatingsView.stringValue = "- #{message.negative_ratings.join(", ")}"
    end
  end

end