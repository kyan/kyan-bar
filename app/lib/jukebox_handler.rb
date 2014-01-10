class JukeboxHandler

  attr_accessor :jukebox

  def initialize(jukebox)
    @jukebox = jukebox

    @update_observer = App.notification_center.observe JB_MESSAGE_RECEIVED do |n|
      refresh!(n.userInfo)
    end
  end

  def self.build
    jb = KyanJukebox::Notify.new([:track, :playlist, :rating])
    jb.json_parser = BW::JSON

    new jb
  end

  private

  def refresh!(data)
    json_txt = data[:msg].dataUsingEncoding(NSUTF8StringEncoding)
    jukebox.update!(json_txt)

    after_update
  rescue BubbleWrap::JSON::ParserError
  end

  def after_update
    App.notification_center.post(JB_UPDATED, nil, {jukebox:jukebox})
    do_notifications
  end

  def do_notifications
    jukebox.notifications.each do |message|
      gcdq = Dispatch::Queue.new('com.kyan.kyanbar')
      gcdq.async do
        notification = NSUserNotification.new
        notification.title = message.heading
        notification.subtitle = message.subtitle
        notification.informativeText = message.description

        if !message.artwork_url.nil?
          url = NSURL.URLWithString(message.artwork_url)
          if url
            artwork_image = NSImage.alloc.initWithContentsOfURL(url)
            notification.contentImage = artwork_image
          end
        end

        NSUserNotificationCenter.defaultUserNotificationCenter.scheduleNotification(notification)
      end
    end
  end

end