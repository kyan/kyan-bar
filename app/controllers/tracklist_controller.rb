class TracklistController < NSViewController

  def init
    super.tap do
      build_view
    end
  end

  def build_view
    @main_view = TracklistView.alloc.initWithFrame([[0, 0], [200, 50]])
    @main_view.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable
    self.setView(@main_view)
  end

end