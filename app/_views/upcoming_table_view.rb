class UpcomingTableView < NSTableView

  def init
    super.tap do |v|
      v.translatesAutoresizingMaskIntoConstraints = false

      col1 = NSTableColumn.alloc.initWithIdentifier "col1"
      col1.setWidth 18
      col1.identifier = :blank
      v.addTableColumn col1

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

      col5 = NSTableColumn.alloc.initWithIdentifier "col5"
      col5.setWidth 18
      col5.identifier = :blank
      v.addTableColumn col5
    end
  end

end
