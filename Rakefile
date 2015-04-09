# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'

require 'bundler'
Bundler.require

require 'bubble-wrap/core'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'KyanBar'
  app.icon = "icon.icns"
  app.identifier = 'com.kyan.kyanbar'
  app.deployment_target = '10.8'
  app.codesign_for_release = false

  app.info_plist['NSUIElement'] = 1
  app.info_plist['NSHumanReadableCopyright'] = 'Copyright © 2013, Kyan Ltd'

  app.pods do
    pod 'SocketRocket'
    pod 'MASShortcut'
    pod "AFNetworking"
  end

  app.sparkle do
    release :base_url, 'https://raw.github.com/kyan/kyan_bar/master'
    release :package_base_url, 'https://github.com/kyan/kyan_bar/releases/download'
    release :version, '1.5'

    # Optional settings
    release :feed_filename, 'releases.xml'
    release :package_filename, "#{app.name}.zip"
    release :public_key, 'dsa_pub.pem'
    release :notes_filename, 'release_notes.html'
  end
end

desc "Runs clean, build:release, sparkle:clean and sparkle:package at once"
task :do_release do
  Rake::Task["clean"].invoke
  Rake::Task["build:release"].invoke
  Rake::Task["sparkle:clean"].invoke
  Rake::Task["sparkle:package"].invoke
end
