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

  // This is our Scene. We are not using Settings
  var body: some Scene {
    Settings {
      EmptyView()
    }
  }
}

// Our AppDelegae will handle our menu
class AppDelegate: NSObject, NSApplicationDelegate {
  static private(set) var instance: AppDelegate!

  // The NSStatusBar manages a collection of status items displayed within a system-wide menu bar.
  lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  // Define what updaterController will be
  let updaterController: SPUStandardUpdaterController
  // Create an instance of our custom main menu we are building
  let menu = MainMenu()

  override init() {
    // This plumbs in the 3rd party Sparkle updater framework
    // If you want to start the updater manually, pass false to startingUpdater and call .startUpdater() later
    // This is where you can also pass an updater delegate if you need one
    updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
  }

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    AppDelegate.instance = self

    // TODO: This should not be probably created here
    // This is the menu items that users can click to check for updates
    let checkForUpdatesMenuItem = NSMenuItem(
      title: "Check For Updates...",
      action: #selector(SPUStandardUpdaterController.checkForUpdates(_:)),
      keyEquivalent: ""
    )
    checkForUpdatesMenuItem.target = updaterController

    // Here we are using a custom icon found in Assets.xcassets
    statusBarItem.button?.image = NSImage(named: NSImage.Name("kyan-logo"))
    statusBarItem.button?.imagePosition = .imageLeading
    // Assign our custom menu to the status bar
    statusBarItem.menu = menu.build(updatesMenuItem: checkForUpdatesMenuItem)
  }
}
