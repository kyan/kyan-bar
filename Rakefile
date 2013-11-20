# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'

require 'bundler'
Bundler.require

require 'bubble-wrap/core'
require 'bubble-wrap/http'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'KyanBar'
  app.icon = "icon.icns"
  app.version = "1.0"
  app.short_version = '1'
  app.identifier = 'com.kyan.'
  app.deployment_target = '10.8'

  app.info_plist['NSUIElement'] = 1
  app.info_plist['NSHumanReadableCopyright'] = 'Copyright © 2013, Kyan Ltd'

  app.pods do
    pod 'SocketRocket'
  end
end