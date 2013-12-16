class WebsocketConnector

  attr_accessor :websocket, :url, :reconn_interval

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
    @connected       = false
    @reconn_interval = @reconn_interval >= 0.1 ? @reconn_interval * 2 : 0.1
    @reconn_interval = [60.0, @reconn_interval].min

    connect
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
    @connected = true
    WebsocketConnector.instance.reset_reconn_interval!
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