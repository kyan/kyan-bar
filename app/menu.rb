class AppDelegate
  def setupMenu
    @menu = NSMenu.new
    @menu.initWithTitle App.name

    build_now_playing
    add_seperator_for(@menu)

    @track_list = TracklistController.new
    mi = NSMenuItem.new
    mi.view = @track_list.view
    @menu.addItem mi

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

    add_seperator_for(sub_menu)

    mi = NSMenuItem.new
    mi.title = 'About KyanBar'
    mi.action = 'orderFrontStandardAboutPanel:'
    sub_menu.addItem mi

    add_seperator_for(sub_menu)

    mi = NSMenuItem.new
    mi.title = 'Quit'
    mi.action = 'terminate:'
    sub_menu.addItem mi

    add_seperator_for(@menu)

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

  def open_link(sender)
    url = NSURL.URLWithString( url_for_index(sender.tag) )
    NSWorkspace.sharedWorkspace.openURL(url)
  end

  def add_seperator_for(menu)
    menu.addItem NSMenuItem.separatorItem
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
