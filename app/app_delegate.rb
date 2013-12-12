class AppDelegate

  attr_accessor :jukebox

  def applicationDidFinishLaunching(notification)
    build_jukebox
    build_status
    handle_notifications

    connect_to_websocket_server
  end

  def build_status
    @status_bar_image = NSImage.imageNamed("k_logo_col_18x18")
    @status_bar_image_alt = NSImage.imageNamed("k_logo_bw_18x18")

    statusBar = NSStatusBar.systemStatusBar
    @status_item = statusBar.statusItemWithLength(NSVariableStatusItemLength)
    @status_item.setImage(@status_bar_image)
    @status_item.setAlternateImage(@status_bar_image_alt)
    @status_item.setHighlightMode(true)
    @menu = setupMenu
    @status_item.setMenu(@menu)
  end

  def build_preferences(sender)
    @preferences ||= PreferencesController.alloc.init
    @preferences.window.makeKeyAndOrderFront(self)
    App.shared.activateIgnoringOtherApps(true)
  end

  def build_jukebox
    @jukebox ||= KyanJukebox::Notify.new([:track, :playlist])
    @jukebox.json_parser = BW::JSON
  end

  def connect_to_websocket_server
    @websocket_server ||= WebsocketConnector.new(WEBSOCKET_URL).connect
  end

  def handle_notifications
    NSUserNotificationCenter.defaultUserNotificationCenter.setDelegate(self)
  end

  def userNotificationCenter(center, shouldPresentNotification:notification)
    true
  end
end