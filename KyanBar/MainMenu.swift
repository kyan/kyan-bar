//
//  MainMenu.swift
//  kyan
//
//  Created by Duncan Robertson on 04/11/2021.
//

import Cocoa
import SwiftUI

// This is our custom menu that will appear when users
// click on the menu bar icon
class MainMenu: NSObject {
  // A new menu instance ready to add items to
  let menu = NSMenu()
  // These are the available links shown in the menu
  // These are fetched from the Info.plist file
  let menuItems = Bundle.main.object(forInfoDictionaryKey: "KyanLinks") as! [String: String]

  // function called by KyanBarApp to create the menu
  func build(updatesMenuItem: NSMenuItem) -> NSMenu {
    // Initialse the custom now playing view
    let nowPlayingView = NowPlayingView()
    // We need this to allow use to stick a SwiftUI view into a
    // a location an NSView would normally be placed
    let contentView = NSHostingController(rootView: nowPlayingView)
    // Setting a size for our now playing view
    contentView.view.frame.size = CGSize(width: 200, height: 80)

    // This is where we actually add our now playing view to the menu
    let customMenuItem = NSMenuItem()
    customMenuItem.view = contentView.view
    menu.addItem(customMenuItem)

    // Adding a seperator
    menu.addItem(NSMenuItem.separator())

    // We add an About pane.
    let aboutMenuItem = NSMenuItem(
      title: "About KyanBar",
      action: #selector(about),
      keyEquivalent: ""
    )
    // This is important so that our #selector
    // targets the `about` func in this file
    aboutMenuItem.target = self

    // This is where we actually add our about item to the menu
    menu.addItem(aboutMenuItem)
    // This is where we actually add the updates menu item we pass in
    menu.addItem(updatesMenuItem)

    // Adding a seperator
    menu.addItem(NSMenuItem.separator())

    // Loop though our sorted link list and create a new menu item for
    // each, and then add it to the menu
    for (title, link) in menuItems.sorted( by: { $0.0 < $1.0 }) {
      let menuItem = NSMenuItem(
        title: title,
        action: #selector(linkSelector),
        keyEquivalent: ""
      )
      menuItem.target = self
      menuItem.representedObject = link

      menu.addItem(menuItem)
    }

    // Adding a seperator
    menu.addItem(NSMenuItem.separator())

    // Adding a quit menu item
    let quitMenuItem = NSMenuItem(
      title: "Quit KyanBar",
      action: #selector(quit),
      keyEquivalent: "q"
    )
    quitMenuItem.target = self
    menu.addItem(quitMenuItem)

    return menu
  }

  // The selector that takes a link and opens it
  // in your default browser
  @objc func linkSelector(sender: NSMenuItem) {
    let link = sender.representedObject as! String
    guard let url = URL(string: link) else { return }
    NSWorkspace.shared.open(url)
  }

  // The selector that opens a standard about pane.
  // You can see we also customise what appears in our
  // about pane by creating a Credits.html file in the root
  // of the project
  @objc func about(sender: NSMenuItem) {
    NSApp.orderFrontStandardAboutPanel()
  }

  // The selector that quits the app
  @objc func quit(sender: NSMenuItem) {
    NSApp.terminate(self)
  }
}
