class NowplayingController < NSViewController

  def init
    super.tap do |c|
      c.build_view

      @update_observer = App.notification_center.observe JB_UPDATED do |n|
        @main_view.refresh(n.userInfo[:jukebox])
      end
    end
  end

  def build_view
    @main_view = NowplayingView.alloc.initWithFrame([[0, 0], [50, 50]])
    self.setView(@main_view)
  end

end