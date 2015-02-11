module KyanBar
  class Notifier
    attr_reader :notifications

    def initialize(notifications=[])
      @notifications = notifications
    end

    def self.send!(notifications)
      new(notifications).process!
    end

    def process!
      notifications.each do |message|
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
end