# Kyan Bar

A demo status bar app for macOS:

![KyanBar](/docs/kyanbar.png)


This is a little app we created for the team at https://kyan.com to access popular services and also to see what's playing on [our office jukebox](https://github.com/kyan/jukebox-js).

It's also acts as a bit of a template for building apps that run in the status bar on macOS. It includes:

* How to adds external links via `NSMenu` and `NSMenuItem`
* How to add a SwiftUI View as a custom menu item
* How to add a SwiftUI Preview with example data
* How to load remote JSON and render the UI using `Async/Await`
* How to load an image with progress using `AsyncImage`
* How to add an About pane
* How to add a custom icon for the app
* How to include the Sparkle update library for easy updates
* How to read information from your Info.plist file

The app is written using [Swift](https://developer.apple.com/swift/) and [SwiftUI](https://developer.apple.com/xcode/swiftui/) and is currently targeting macOS 12 (Monterey) and greater.

## Build

* Choose Product -> Archive
* Go to Window -> Organizer
* Choose your app and click Distribute App
* Choose Developer ID from list and then Next
* Choose Upload (to send to Notary service) and then Next
* Once you get a Ready to distribute status
* Choose your app and click Export Notorized App
* Export to `builds` folder in the repo
* You can now zip up the app for distribution

### To update the `appcast.xml` file

```
./Pods/Sparkle/bin/generate_appcast builds/
```

This will create an updated `appcast.xml` which you can use in the root of the project. You may need to change the `enclosure:url` to point to where the application zip has been uploaded to.
