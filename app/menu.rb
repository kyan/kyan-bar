class AppDelegate
  def setupMenu
    menu = NSMenu.new
    menu.initWithTitle App.name

    links.each_with_index do |data, i|
      m = NSMenuItem.new
      m.title = data.first
      m.tag = i
      m.setImage( NSImage.imageNamed(data.first.downcase) )
      m.action = 'open_link:'
      menu.addItem m
    end

    add_seperator(menu)

    mi = NSMenuItem.new
    mi.title = 'Preferences...'
    mi.action = 'build_preferences:'
    menu.addItem mi

    mi = NSMenuItem.new
    mi.title = 'Check for updates...'
    mi.action = 'checkForUpdates:'
    mi.target = SUUpdater.new
    menu.addItem mi

    mi = NSMenuItem.new
    mi.title = 'Quit'
    mi.action = 'terminate:'
    menu.addItem mi

    menu
  end

  def open_link(sender)
    url = NSURL.URLWithString( url_for_index(sender.tag) )
    NSWorkspace.sharedWorkspace.openURL(url)
  end

  private

  def add_seperator(menu)
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
