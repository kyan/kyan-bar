class TracklistView < NSView

  attr_accessor :jukebox

  def init
    super.tap do
    end
  end

  def playlist
    jukebox.playlist unless jukebox.nil?
  end

  def viewWillDraw
    super
  end

  def drawRect(dirtyRect)
    @label = NSTextField.alloc.initWithFrame([[32, 0], [150, 30]])
    @label.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin|NSViewWidthSizable
    @label.editable = false
    #@label.setBezeled(false)
    @label.setDrawsBackground(false)
    @label.setSelectable(false)
    @label.setStringValue("Hello")

    addSubview(@label)
  end

  # def build_upcoming_tracks
  #   playlist.take(3).each do |track|
  #     m = NSMenuItem.new
  #     m.setAttributedTitle(
  #       track.title.attrd({
  #         'NSFont' => NSFont.fontWithName("Lucida Grande", size:12),
  #         'NSColor' => NSColor.blackColor
  #       }) + "\n" +
  #       track.artist.attrd({
  #         'NSFont' => NSFont.fontWithName("Lucida Grande", size:10),
  #         'NSColor' => NSColor.darkGrayColor
  #       })  + " - " +
  #       track.album.attrd({
  #         'NSFont' => NSFont.fontWithName("Lucida Grande", size:10),
  #         'NSColor' => NSColor.lightGrayColor
  #       })
  #     )
  #     m.tag = track.dbid
  #     add_menu_icon_for(m, track.artwork_url)

  #     @menu.addItem m
  #   end

  #   add_seperator_for(@menu)
  # end

  # def add_menu_icon_for(menu, img_url)
  #   image_url = if img_url.nil?
  #     "http://www.appledystopia.com/wp-content/uploads/2013/03/missing-itunes-album-art-icon.png"
  #   else
  #     img_url
  #   end

  #   Dispatch::Queue.concurrent.async do
  #     new_size = NSMakeSize(32, 32)
  #     url   = NSURL.URLWithString(image_url)
  #     image_data = NSData.alloc.initWithContentsOfURL(url)
  #     image = NSImage.alloc.initWithData(image_data)
  #     image.setScalesWhenResized(true)

  #     resized_img = NSImage.alloc.initWithSize(new_size)
  #     originalSize = image.size

  #     resized_img.lockFocus
  #     image.setSize(new_size)
  #     NSGraphicsContext.currentContext.setImageInterpolation(NSImageInterpolationHigh)
  #     image.drawAtPoint(
  #       NSZeroPoint,
  #       fromRect: CGRectMake(0, 0, new_size.width, new_size.height),
  #       operation: NSCompositeCopy,
  #       fraction:1.0
  #       )
  #     resized_img.unlockFocus

  #     menu.setImage(resized_img)
  #   end
  # end

end