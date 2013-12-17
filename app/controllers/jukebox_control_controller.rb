class JukeboxControlController < NSWindowController

  def init
    super.tap do
      build_window

      @update_observer = App.notification_center.observe JB_UPDATED do |n|
        puts "jukebox updated! .. do something"
      end
    end
  end

  private

  def build_window
    @window ||= JukeboxControlWindow.build
    @window.title = "Jukebox Control"
    self.setWindow(@window)
  end
end