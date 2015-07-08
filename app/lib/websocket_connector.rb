class WebsocketConnector

  attr_accessor :websocket, :url, :reconn_interval, :connected

  def self.instance
    Dispatch.once { @instance ||= new }
    @instance
  end

  def initialize
    @connected = false
    reset_reconn_interval!
  end

  def connect
    websocket_url = NSURL.URLWithString(url)
    @websocket = SRWebSocket.new
    @websocket.initWithURL(websocket_url)
    @websocket.delegate = WebsocketConnector
    @websocket.open
  end

  def reconnect
    App.notification_center.post(JB_IS_CONNECTED, nil, { state: false })

    @connected       = false
    @reconn_interval = @reconn_interval >= 0.1 ? @reconn_interval * 2 : 0.1
    @reconn_interval = [60.0, @reconn_interval].min

    connect
  end

  def self.reconnect_with_timer
    wsinstance =  WebsocketConnector.instance

    NSTimer.scheduledTimerWithTimeInterval(
      wsinstance.reconn_interval,
      target:wsinstance,
      selector:'reconnect',
      userInfo:nil,
      repeats: false
    )
  end

  def force_reconnect!
    reset_reconn_interval!
    reconnect
  end

  def connected?
    @connected
  end

  def reset_reconn_interval!
    @reconn_interval = 0.0
  end

  def self.webSocket(webSocket, didReceiveMessage:msg)
    App.notification_center.post(JB_MESSAGE_RECEIVED, nil, { msg:msg })
  end

  def self.webSocketDidOpen(webSocket)
    WebsocketConnector.instance.tap do |ws|
      ws.connected = true
      ws.reset_reconn_interval!

      App.notification_center.post(JB_IS_CONNECTED, nil, { state: true })
    end
  end

  def self.webSocket(webSocket, didFailWithError:error_ptr)
    reconnect_with_timer
  end

  def self.webSocket(webSocket, didCloseWithCode:code, reason:reason, wasClean:wasClean)
    reconnect_with_timer
  end

end