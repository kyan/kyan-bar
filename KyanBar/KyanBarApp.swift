//
//  kyanBar.swift
//  kyan
//
//  Created by Duncan Robertson on 01/11/2021.
//

import Cocoa
import SwiftUI
import Sparkle

@main
struct kyanApp: App {
  // swiftlint:disable:next weak_delegate
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  var body: some Scene {
    Settings {
      EmptyView()
    }
  }
}

class AppDelegate: NSObject, NSApplicationDelegate {
  static private(set) var instance: AppDelegate!
  
  lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  let updaterController: SPUStandardUpdaterController
  let menu = MainMenu()
  
  override init() {
    // If you want to start the updater manually, pass false to startingUpdater and call .startUpdater() later
    // This is where you can also pass an updater delegate if you need one
    updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
  }
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    AppDelegate.instance = self
    
    // TODO: This should not be probably created here
    let checkForUpdatesMenuItem = NSMenuItem(
      title: "Check For Updates...",
      action: #selector(SPUStandardUpdaterController.checkForUpdates(_:)),
      keyEquivalent: ""
    )
    checkForUpdatesMenuItem.target = updaterController
    
    statusBarItem.button?.image = NSImage(named: NSImage.Name("kyan-logo"))
    statusBarItem.button?.imagePosition = .imageLeading
    statusBarItem.menu = menu.build(updatesMenuItem: checkForUpdatesMenuItem)
  }
}
