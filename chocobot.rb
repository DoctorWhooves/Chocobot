#!/usr/bin/env ruby
require "yaml"
require "./chocobot.irc.rb"

config = YAML.load_file("config.yml")

irc = ChocobotIRC.new(config["server"], config["port"], config["nick"], config["pass"], config["channel"])
irc.connect()
begin
    irc.main_loop()
rescue Interrupt
rescue Exception => detail
    retry
end