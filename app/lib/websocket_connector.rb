class WebsocketConnector

  attr_accessor :websocket

  def initialize(url)
    @reconn_interval = 0.0
    @websocket_url = url
  end

  def connect
    url = NSURL.URLWithString(@websocket_url)
    @websocket = SRWebSocket.new
    @websocket.initWithURL(url)
    @websocket.delegate = WebsocketConnector
    @websocket.open
  end

  def reconnect
    @reconn_interval = @reconn_interval >= 0.1 ? @reconn_interval * 2 : 0.1
    @reconn_interval = [60.0, @reconn_interval].min

    connect
  end

  def self.webSocket(webSocket, didReceiveMessage:msg)
    App.notification_center.post(JB_MESSAGE_RECEIVED, nil, { msg:msg })
  end

  def self.webSocketDidOpen(webSocket)
    @reconn_interval = 0.0
  end

  def self.webSocket(webSocket, didFailWithError:error)
    NSTimer.scheduledTimerWithTimeInterval(@reconn_interval,
      target:self,
      selector:'reconnect',
      userInfo:nil,
      repeats: false
      )
  end

  def self.webSocket(webSocket, didCloseWithCode:code, reason:reason, wasClean:wasClean)
    # Bang!
  end

end