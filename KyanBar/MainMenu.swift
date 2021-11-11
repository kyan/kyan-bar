//
//  MainMenu.swift
//  kyan
//
//  Created by Duncan Robertson on 04/11/2021.
//

import Cocoa
import SwiftUI

class MainMenu: NSObject {
  let menu = NSMenu()
  let menuItems: [String: String] = [
    "Handbook": "https://handbook.kyan.com/",
    "Holiday": "https://app.timetastic.co.uk/wallchart",
    "Lattice": "https://kyan.latticehq.com/",
    "Jukebox": "http://jukebox.kyan.com"
  ]

  func build() -> NSMenu {
    let aboutMenuItem = NSMenuItem(
      title: "About KyanBar",
      action: #selector(about),
      keyEquivalent: ""
    )
    aboutMenuItem.target = self
    
    menu.addItem(aboutMenuItem)
    menu.addItem(NSMenuItem.separator())
    
    let nowPlayingView = NowPlayingView()
    let contentView = NSHostingController(rootView: nowPlayingView)
    contentView.view.frame.size = CGSize(width: 200, height: 50)
    
    let customMenuItem = NSMenuItem()
    customMenuItem.view = contentView.view
    menu.addItem(customMenuItem)
    
    menu.addItem(NSMenuItem.separator())
    
    for (title, link) in menuItems {
      let menuItem = NSMenuItem(
        title: title,
        action: #selector(hello),
        keyEquivalent: ""
      )
      menuItem.target = self
      menuItem.representedObject = link

      menu.addItem(menuItem)
    }
    
    menu.addItem(NSMenuItem.separator())
    
    let quitMenuItem = NSMenuItem(
      title: "Quit KyanBar",
      action: #selector(quit),
      keyEquivalent: "q"
    )
    quitMenuItem.target = self
    menu.addItem(quitMenuItem)

    return menu
  }

  @objc func hello(sender: NSMenuItem) {
    let link = sender.representedObject as! String
    guard let url = URL(string: link) else { return }
    NSWorkspace.shared.open(url)
  }
  
  @objc func about(sender: NSMenuItem) {
    NSApp.orderFrontStandardAboutPanel()
  }
  
  @objc func quit(sender: NSMenuItem) {
    NSApp.terminate(self)
  }
}
