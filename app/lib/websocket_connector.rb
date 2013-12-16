class WebsocketConnector

  attr_accessor :websocket, :url, :reconn_interval

  def self.instance
    Dispatch.once { @instance ||= new }
    @instance
  end

  def initialize
    @reconn_interval = 0.0
  end

  def connect
    websocket_url = NSURL.URLWithString(url)
    @websocket = SRWebSocket.new
    @websocket.initWithURL(websocket_url)
    @websocket.delegate = WebsocketConnector
    @websocket.open
  end

  def reconnect
    @reconn_interval = @reconn_interval >= 0.1 ? @reconn_interval * 2 : 0.1
    @reconn_interval = [60.0, @reconn_interval].min

    connect
  end

  def self.webSocket(webSocket, didReceiveMessage:msg)
    jukebox = App.shared.delegate.jukebox
    jukebox.update!(msg.dataUsingEncoding(NSUTF8StringEncoding))
    jukebox.notifications.each do |message|
      notification = NSUserNotification.alloc.init
      notification.title = message.heading
      notification.subtitle = message.subtitle
      notification.informativeText = message.description

      NSUserNotificationCenter.defaultUserNotificationCenter.scheduleNotification(notification)
    end
  end

  def self.webSocketDidOpen(webSocket)
    WebsocketConnector.instance.reconn_interval = 0.0
  end

  def self.webSocket(webSocket, didFailWithError:error_ptr)
    wsinstance =  WebsocketConnector.instance
    NSTimer.scheduledTimerWithTimeInterval(
      wsinstance.reconn_interval,
      target:wsinstance,
      selector:'reconnect',
      userInfo:nil,
      repeats: false
      )
  end

  def self.webSocket(webSocket, didCloseWithCode:code, reason:reason, wasClean:wasClean)
    # Bang!
  end

end