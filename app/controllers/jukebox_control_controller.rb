class JukeboxControlController < NSWindowController

  attr_accessor :jukebox

  def init
    super.tap do
    end
  end

  def setup(jukebox)
    @jukebox = WeakRef.new(jukebox)
    build_window
  end

  private

  def build_window
    @window ||= JukeboxControlWindow.build
    @window.nowplaying_controller.view.refresh(jukebox)
    @window.title = "Jukebox Control"
    self.setWindow(@window)
  end
end