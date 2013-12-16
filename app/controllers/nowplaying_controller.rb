class NowplayingController < NSViewController

  def init
    super.tap do
      build_view
    end
  end

  def build_view
    @main_view = NowplayingView.alloc.initWithFrame([[0, 0], [240, 52]])
    @main_view.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable
    self.setView(@main_view)
  end

end