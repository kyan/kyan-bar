//
//  ContentView.swift
//  kyan
//
//  Created by Duncan Robertson on 01/11/2021.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    List {
      Button("The Return of the King", action: placeOrder)
      Button("Print message") {
        print("Hello World!")
      }.keyboardShortcut("p")
      Divider()
      Text("The Return of the King")
      Link("View Our Terms of Service",
            destination: URL(string: "https://www.example.com/TOS.html")!)
      Text("The Return of the King")
    }
  }
  
  func placeOrder() {
    print("hello")
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
