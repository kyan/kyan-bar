class AppDelegate

  attr_reader :websocket_server

  def applicationDidFinishLaunching(notification)
    NSUserNotificationCenter.defaultUserNotificationCenter.setDelegate(self)

    build_jukebox
    connect_to_websocket_server
    build_status
  end

  def build_status
    status_bar_image     = NSImage.imageNamed("k_logo_col_18x18")
    status_bar_image_alt = NSImage.imageNamed("k_logo_bw_18x18")

    statusBar = NSStatusBar.systemStatusBar
    bar = statusBar.statusItemWithLength(NSVariableStatusItemLength)
    bar.retain
    bar.setImage(status_bar_image)
    bar.setAlternateImage(status_bar_image_alt)
    bar.setHighlightMode(true)

    build_menu
    bar.setMenu(@menu)
  end

  def build_preferences(sender)
    @preferences ||= PreferencesController.new
    @preferences.window.makeKeyAndOrderFront(self)
    App.shared.activateIgnoringOtherApps(true)
  end

  def build_jukebox_controls(sender)
    @jukebox_controls ||= JukeboxControlController.new
    @jukebox_controls.setup(jukebox)
    @jukebox_controls.window.makeKeyAndOrderFront(self)
    App.shared.activateIgnoringOtherApps(true)
  end

  def build_jukebox
    @jukebox_handler = JukeboxHandler.build
  end

  def jukebox
    @jukebox_handler.jukebox unless @jukebox_handler.nil?
  end

  def jukebox_available?
    WebsocketConnector.instance.connected? && !jukebox.nil?
  end

  def connect_to_websocket_server
    WebsocketConnector.instance.tap do |ws|
      ws.url = WEBSOCKET_URL
      ws.connect
    end
  end

  def userNotificationCenter(center, shouldPresentNotification:notification)
    true
  end
end
