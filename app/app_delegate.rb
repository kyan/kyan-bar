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

    status_bar = NSStatusBar.systemStatusBar
    bar = status_bar.statusItemWithLength(NSVariableStatusItemLength)
    bar.retain
    bar.setImage(@status_bar_image)
    bar.setAlternateImage(@status_bar_image_alt)
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
    @jukebox ||= KyanJukebox::Notify.new([:track, :playlist])
    @jukebox.json_parser = BW::JSON

    @update_observer = App.notification_center.observe JB_MESSAGE_RECEIVED do |n|
      update_jukebox(n.userInfo)
    end
  end

  def update_jukebox(data)
    json_txt = data[:msg].dataUsingEncoding(NSUTF8StringEncoding)

    begin
      @jukebox.update!(json_txt)
    rescue BubbleWrap::JSON::ParserError
    end

    @jukebox.notifications.each do |message|
      notification = NSUserNotification.alloc.init
      notification.title = message.heading
      notification.subtitle = message.subtitle
      notification.informativeText = message.description

      NSUserNotificationCenter.defaultUserNotificationCenter.scheduleNotification(notification)
    end
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