# Kyan Bar

A StatusBar app for use in the Kyan office. Current features:

* Links to common apps
* Jukebox now playing information

The app is written using RubyMotion and was created to understand this method of development.

# Install

You can run in dev mode using

`rake`

or build a real app using:

`rake build`

which will create a real app in the `build` dir, you can put in your Applications folder.

# Build new version

<pre>
rake build:release
rake sparkle:clean
rake sparkle:package
</pre>

You will need to copy the contents of sparkle/releases into the root files