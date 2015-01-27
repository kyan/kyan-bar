class AppDelegate

  attr_reader :websocket_server

  def applicationDidFinishLaunching(notification)
    NSUserNotificationCenter.defaultUserNotificationCenter.setDelegate(self)

    register_defaults
    build_jukebox
    build_status

    show_jukebox_controls

    @connection_observer = App.notification_center.observe JB_IS_CONNECTED do |n|
      handle_websocket_connection(n)
    end

    connect_to_websocket_server
  end

  def build_status
    statusBar = NSStatusBar.systemStatusBar
    @bar = statusBar.statusItemWithLength(NSVariableStatusItemLength)
    @bar.retain
    @bar.setHighlightMode(true)

    setup_build_menu
    @bar.setMenu(@menu)

    update_status_bar_icon(false)
  end

  def build_preferences(sender)
    @preferences ||= PreferencesController.new
    @preferences.window.makeKeyAndOrderFront(self)
    App.shared.activateIgnoringOtherApps(true)
  end

  def update_status_bar_icon(active=true)
    img = NSImage.imageNamed((active ? SB_ICON_ACTIVE : SB_ICON_INACTIVE))
    @bar.setImage(img)
  end

  def build_jukebox_controls
    @jukebox_controls ||= JukeboxControlController.new
    @jukebox_controls.setup(jukebox)
    @jukebox_controls.window.makeKeyAndOrderFront(self)
    App.shared.activateIgnoringOtherApps(true)

    update_jukebox_controls_button_state(NSOnState)
  end

  def remove_jukebox_controls
    @jukebox_controls.close unless @jukebox_controls.nil?
  end

  def hide_jukebox_controls
    update_jukebox_controls_button_state(NSOffState)
    remove_jukebox_controls
  end

  def show_jukebox_controls
    if Persistence.get(SHOW_JB_DEFAULT) == 1
      build_jukebox_controls
    end
  end

  def force_reconnect_to_websocket_server
    WebsocketConnector.instance.force_reconnect!
  end

  def register_defaults
    NSUserDefaults.standardUserDefaults.registerDefaults(
      { SHOW_JB_DEFAULT => false }
    )

    MASShortcutBinder.sharedBinder.bindShortcutWithDefaultsKey(U_VOTE_SHORTCUT_VAR,
      toAction: lambda do
        VoteHandler.register(true)
      end
    )

    MASShortcutBinder.sharedBinder.bindShortcutWithDefaultsKey(D_VOTE_SHORTCUT_VAR,
      toAction: lambda do
        VoteHandler.register(false)
      end
    )
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

  def update_jukebox_controls_button_state(state)
    Persistence.set(SHOW_JB_DEFAULT, state)
  end

  def handle_websocket_connection(n)
    state = n.userInfo[:state]

    if state == true
      show_jukebox_controls
    else
      remove_jukebox_controls
      update_status_bar_icon(false)
    end
  end
end
