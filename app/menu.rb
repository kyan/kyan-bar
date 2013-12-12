class AppDelegate
  def setupMenu
    @menu = NSMenu.new
    @menu.initWithTitle App.name

    build_now_playing
    add_seperator

    unless jukebox.playlist.empty?
      build_upcoming_tracks
    end

    links.each_with_index do |data, i|
      m = NSMenuItem.new
      m.title = data.first
      m.tag = i
      m.setImage( NSImage.imageNamed(data.first.downcase) )
      m.action = 'open_link:'
      @menu.addItem m
    end

    build_submenu

    @menu
  end

  private

  def build_submenu
    sub_menu = NSMenu.new
    mi = NSMenuItem.new
    mi.title = 'Preferences...'
    mi.action = 'build_preferences:'
    sub_menu.addItem mi

    mi = NSMenuItem.new
    mi.title = 'Check for updates...'
    mi.action = 'checkForUpdates:'
    mi.target = SUUpdater.new
    sub_menu.addItem mi

    mi = NSMenuItem.new
    mi.title = 'Quit'
    mi.action = 'terminate:'
    sub_menu.addItem mi

    add_seperator

    mi = NSMenuItem.new
    mi.title = 'Settings'
    mi.setSubmenu(sub_menu)
    @menu.addItem mi
  end

  def build_now_playing
    @jukebox_menu = NSViewController.alloc.initWithNibName("Jukebox", bundle:nil)
    @jukebox_view = @jukebox_menu.view
    @jukebox_view.jukebox = jukebox

    mi = NSMenuItem.new
    mi.view = @jukebox_view
    @menu.addItem mi
  end

  def build_upcoming_tracks
    jukebox.playlist.take(3).each do |track|
      m = NSMenuItem.new
      m.setAttributedTitle(
        track.title.attrd({
          'NSFont' => NSFont.fontWithName("Lucida Grande", size:12),
          'NSColor' => NSColor.blackColor
        }) + "\n" +
        track.artist.attrd({
          'NSFont' => NSFont.fontWithName("Lucida Grande", size:10),
          'NSColor' => NSColor.darkGrayColor
        })  + " - " +
        track.album.attrd({
          'NSFont' => NSFont.fontWithName("Lucida Grande", size:10),
          'NSColor' => NSColor.lightGrayColor
        })
      )
      m.tag = track.dbid
      add_menu_icon_for(m, track.artwork_url)

      @menu.addItem m
    end

    add_seperator if jukebox.playlist.any?
  end

  def add_menu_icon_for(menu, img_url)
    image_url = if img_url.nil?
      "http://www.appledystopia.com/wp-content/uploads/2013/03/missing-itunes-album-art-icon.png"
    else
      img_url
    end

    Dispatch::Queue.concurrent.async do
      new_size = NSMakeSize(32, 32)
      url   = NSURL.URLWithString(image_url)
      image_data = NSData.alloc.initWithContentsOfURL(url)
      image = NSImage.alloc.initWithData(image_data)
      image.setScalesWhenResized(true)

      resized_img = NSImage.alloc.initWithSize(new_size)
      originalSize = image.size

      resized_img.lockFocus
      image.setSize(new_size)
      NSGraphicsContext.currentContext.setImageInterpolation(NSImageInterpolationHigh)
      image.drawAtPoint(
        NSZeroPoint,
        fromRect: CGRectMake(0, 0, new_size.width, new_size.height),
        operation: NSCompositeCopy,
        fraction:1.0
        )
      resized_img.unlockFocus

      menu.setImage(resized_img)
    end
  end

  def open_link(sender)
    url = NSURL.URLWithString( url_for_index(sender.tag) )
    NSWorkspace.sharedWorkspace.openURL(url)
  end

  def add_seperator
    @menu.addItem NSMenuItem.separatorItem
  end

  def links
    [
      ["Timesheet"      , "https://gapps.harvestapp.com/gapp_company?domain=kyanmedia.com"],
      ["Pivotal"        , "https://www.pivotaltracker.com/google_domain_openid/redirect_for_auth?domain=kyanmedia.com"],
      ["Support"        , "https://kyan.sirportly.com"],
      ["Holiday"        , "https://appogee-leave.appspot.com/login?domain=kyanmedia.com"],
      ["Campfire"       , "https://kyanmedia.campfirenow.com"]
    ]
  end

  def url_for_index(i)
    links[i].last
  end
end
