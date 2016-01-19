class UpcomingTableView < NSTableView

  def init
    super.tap do |v|
      v.translatesAutoresizingMaskIntoConstraints = false

      col2 = NSTableColumn.alloc.initWithIdentifier "col2"
      col2.setWidth 20
      col2.identifier = :thumb
      v.addTableColumn col2

      col3 = NSTableColumn.alloc.initWithIdentifier "col3"
      col3.setWidth 220
      col3.identifier = :title
      v.addTableColumn col3

      col4 = NSTableColumn.alloc.initWithIdentifier "col4"
      col4.setWidth 40
      col4.identifier = :duration
      v.addTableColumn col4
    end
  end

end
