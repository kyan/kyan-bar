//
//  MainMenu.swift
//  kyan
//
//  Created by Duncan Robertson on 04/11/2021.
//

import Cocoa
import Foundation

class MainMenu: NSObject {
  let menu = NSMenu()
  let menuItems: [String: String] = [
    "Holiday":   "https://app.timetastic.co.uk"
  ]

  func build() -> NSMenu {
    
    let aboutMenuItem = NSMenuItem(
      title: "About Kyan",
      action: #selector(about),
      keyEquivalent: ""
    )
    aboutMenuItem.target = self
    
    menu.addItem(aboutMenuItem)
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
}
