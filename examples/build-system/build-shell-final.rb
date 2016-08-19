#!/usr/bin/env ruby

require 'pathname'
require 'etc'
require 'shellwords'

input_path = Pathname.glob('*.c')[0]
input = input_path.to_s.shellescape
output = input_path.sub_ext('').to_s.shellescape
zip = input_path.sub_ext('.zip').to_s.shellescape

# Compile source code
system "cc -o #{output} #{input}"

# Archive source and compiled program
system "zip #{zip} #{input} #{output}"

# Upload to atlas
USER = 'medora'.freeze
HOST = 'atlas'.freeze
REMOTE_DIR = "/mnt/vol1/share/Transfer/shelling-out/#{Etc.getlogin}".shellescape

remote_command = "mkdir -p #{REMOTE_DIR}"
ssh_command = "ssh #{USER}@#{HOST} #{remote_command.shellescape}"
puts ssh_command
system ssh_command
system "scp #{zip} #{USER}@#{HOST}:#{REMOTE_DIR}"
