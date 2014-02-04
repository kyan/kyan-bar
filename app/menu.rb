class AppDelegate

  def setup_build_menu
    @menu = NSMenu.new
    @menu.delegate = self
    @menu.initWithTitle App.name
    @menu.setMinimumWidth(DEFAULT_MENU_WIDTH)
    @jukebox_menu ||= NowplayingController.new
    @upcoming_tracks ||= UpcomingController.new

    build_menu(@menu)

    @menu
  end

  def menuNeedsUpdate(menu)
    build_menu(menu)
  end

  private

  def build_menu(menu)
    menu = setup_build_menu if menu.nil?
    menu.removeAllItems

    flags = (NSEvent.modifierFlags & NSDeviceIndependentModifierFlagsMask)

    # If you hold the ALT key and display the
    # menu it will show an extra item that lets
    # you refersh your connection to the jukebox
    #
    if flags == NSAlternateKeyMask
      menu.addItem(build_secret_refresh)
      add_seperator_for(menu)
    end

    if jukebox_available?
      build_now_playing(menu)
      build_upcoming_tracks(menu)
      build_console_status(menu)
      add_seperator_for(menu)
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
  end

  def build_submenu
    sub_menu = NSMenu.new
    mi = NSMenuItem.new
    mi.title = 'Preferences...'
    mi.action = 'build_preferences:'
    mi.tag = MENU_PREFERENCES
    mi.setKeyEquivalent(",")
    mi.setKeyEquivalentModifierMask(NSCommandKeyMask)
    sub_menu.addItem mi

    mi = NSMenuItem.new
    mi.title = 'Check for updates...'
    mi.action = 'checkForUpdates:'
    mi.tag = MENU_CHECK_FOR_UPDATES
    mi.target = SUUpdater.new
    sub_menu.addItem mi

    add_seperator_for(sub_menu)

    mi = NSMenuItem.new
    mi.title = 'About KyanBar'
    mi.action = 'orderFrontStandardAboutPanel:'
    mi.tag = MENU_ABOUT
    sub_menu.addItem mi

    add_seperator_for(sub_menu)

    mi = NSMenuItem.new
    mi.title = 'Quit'
    mi.action = 'terminate:'
    mi.tag = MENU_QUIT
    mi.setKeyEquivalent("q")
    mi.setKeyEquivalentModifierMask(NSCommandKeyMask)
    sub_menu.addItem mi

    add_seperator_for(@menu)

    mi = NSMenuItem.new
    mi.title = 'Settings'
    mi.tag = MENU_SETTINGS
    mi.setSubmenu(sub_menu)
    @menu.addItem mi
  end

  def build_now_playing(menu)
    jbmi = NSMenuItem.new
    jbmi.tag = MENU_NOWPLAYING
    jbmi.view = @jukebox_menu.view
    menu.addItem(jbmi)
    add_seperator_for(menu)
  end

  def build_upcoming_tracks(menu)
    jbmi = NSMenuItem.new
    jbmi.tag = MENU_NOWPLAYING
    jbmi.view = @upcoming_tracks.view
    menu.addItem(jbmi)
    add_seperator_for(menu)
  end

  def build_secret_refresh
    NSMenuItem.new.tap do |mi|
      mi.title = 'Force Refresh!'
      mi.action = 'force_reconnect_to_websocket_server'
      mi.tag = MENU_FORCE_REFRESH
      mi.setKeyEquivalent("r")
      mi.setKeyEquivalentModifierMask(NSCommandKeyMask)
    end
  end

  def build_console_status(menu)
    butt = NSMenuItem.new
    butt.tag = MENU_CONSOLE_BUTT

    state = Persistence.get(SHOW_JB_DEFAULT)
    state = NSOffState if state.nil?

    if state == NSOnState
      butt.title = 'Hide Jukebox HUD'
      butt.action = 'hide_jukebox_controls'
      butt.setState(NSOnState)
    else
      butt.title = 'Show Jukebox HUD'
      butt.action = 'build_jukebox_controls'
      butt.setState(NSOffState)
    end

    menu.addItem(butt)
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
      ["Holiday"        , "https://app.timetastic.co.uk"],
      ["Chat"           , "https://kyan.hipchat.com/chat"],
      ["Jukebox"       ,  "http://jukebox.local"]
    ]
  end

  def url_for_index(i)
    links[i].last
  end
end
