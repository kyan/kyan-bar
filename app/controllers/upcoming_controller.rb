class UpcomingController < NSViewController

  def init
    super.tap do |c|
      c.build_view

      @update_observer = App.notification_center.observe JB_UPDATED do |n|
        view.refresh(n.userInfo[:jukebox])
      end
    end
  end

  def build_view
    @main_view = UpcomingView.alloc.initWithFrame([[0, 0], [50, 50]])
    @main_view.table.setDelegate(self)
    @main_view.table.setDataSource(self)
    self.setView(@main_view)
  end


  def numberOfRowsInTableView
    3
  end

  def tableView(tableView, objectValueForTableColumn:objVal, row:row)
    'Hello'
  end

end