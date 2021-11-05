//
//  kyanBar.swift
//  kyan
//
//  Created by Duncan Robertson on 01/11/2021.
//

import Cocoa
import SwiftUI

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
  let menu = MainMenu()
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    AppDelegate.instance = self
    
    statusBarItem.button?.image = NSImage(named: NSImage.Name("git"))
    statusBarItem.button?.imagePosition = .imageLeading
    statusBarItem.menu = menu.build()
  }
}
