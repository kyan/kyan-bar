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

  def windowDidBecomeMain(notification)
    choose_window_level
  end

  def windowDidResignMain(notification)
    choose_window_level
  end

  private

  def choose_window_level
    if window_on_top?
      window.setLevel(NSFloatingWindowLevel)
    else
      window.setLevel(NSNormalWindowLevel)
    end
  end

  def window_on_top?
    Persistence.get("alwaysOnTop")
  end

  def build_window
    @window ||= JukeboxControlWindow.build
    @window.delegate = self
    @window.nowplaying_controller.view.refresh(jukebox)
    @window.title = "Jukebox Control"
    self.setWindow(@window)
  end
end