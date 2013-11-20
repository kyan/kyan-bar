class SRWebSocketDelegate

  def self.webSocket(webSocket, didReceiveMessage:msg)
    @jukebox = JukeBox::Notify.new(msg)

    puts msg

    @jukebox.notifications.each do |message|
      notification = NSUserNotification.alloc.init
      notification.title = message.heading
      notification.subtitle = message.subtitle
      notification.informativeText = message.description

      NSUserNotificationCenter.defaultUserNotificationCenter.scheduleNotification(notification)
    end
  end

  def self.webSocketDidOpen(webSocket)
    puts "Socket connection opened!"
  end

  def self.webSocket(webSocket, didFailWithError:error)
    puts "Bang!!"
  end

  def self.webSocket(webSocket, didCloseWithCode:code, reason:reason, wasClean:wasClean)
    puts "Bang again!!"
  end
end