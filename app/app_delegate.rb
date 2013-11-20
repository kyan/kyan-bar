class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildStatus
    handle_notifications
    connect_to_websocket_server
  end

  def buildStatus
    @status_bar_image = NSImage.imageNamed("k_logo_col_18x18")
    @status_bar_image_alt = NSImage.imageNamed("k_logo_bw_18x18")

    status_bar = NSStatusBar.systemStatusBar
    bar = status_bar.statusItemWithLength(NSVariableStatusItemLength)
    bar.retain
    bar.setImage(@status_bar_image)
    bar.setAlternateImage(@status_bar_image_alt)
    bar.setHighlightMode(true)
    @menu = setupMenu
    bar.setMenu(@menu)
  end

  def connect_to_websocket_server
    url = NSURL.URLWithString("ws://jukebox.local:8080")
    @websocket = SRWebSocket.new
    @websocket.initWithURL(url)
    @websocket.delegate = SRWebSocketDelegate
    @websocket.open
  end

  def handle_notifications
    NSUserNotificationCenter.defaultUserNotificationCenter.setDelegate(self)
  end

  def userNotificationCenter(center, shouldPresentNotification:notification)
    true
  end
end