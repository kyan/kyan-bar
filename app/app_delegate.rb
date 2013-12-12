class AppDelegate

  def applicationDidFinishLaunching(notification)
    NSUserNotificationCenter.defaultUserNotificationCenter.setDelegate(self)

    build_jukebox
    build_status
    connect_to_websocket_server
  end

  def build_status
    status_bar_image     = NSImage.imageNamed("k_logo_col_18x18")
    status_bar_image_alt = NSImage.imageNamed("k_logo_bw_18x18")

    status_bar = NSStatusBar.systemStatusBar
    bar = status_bar.statusItemWithLength(NSVariableStatusItemLength)
    bar.retain
    bar.setImage(status_bar_image)
    bar.setAlternateImage(status_bar_image_alt)
    bar.setHighlightMode(true)
    @menu = setupMenu
    bar.setMenu(@menu)
  end

  def build_preferences(sender)
    @preferences ||= PreferencesController.alloc.init
    @preferences.window.makeKeyAndOrderFront(self)
    App.shared.activateIgnoringOtherApps(true)
  end

  def build_jukebox
    @jukebox_handler = JukeboxHandler.build
  end

  def jukebox
    @jukebox_handler.jukebox unless @jukebox_handler.nil?
  end

  def connect_to_websocket_server
    @websocket_server ||= WebsocketConnector.new(WEBSOCKET_URL).connect
  end

  def userNotificationCenter(center, shouldPresentNotification:notification)
    true
  end
end