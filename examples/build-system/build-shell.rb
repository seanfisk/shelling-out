#!/usr/bin/env ruby

require 'pathname'
require 'etc'

input_path = Pathname.glob('*.c')[0]
input = input_path.to_s
output = input_path.sub_ext('')
zip = input_path.sub_ext('.zip')

# Compile source code
system "cc -o #{output} #{input}"

# Archive source and compiled program
system "zip #{zip} #{input} #{output}"

# Upload to atlas
USER = 'medora'.freeze
HOST = 'atlas'.freeze
REMOTE_DIR = "/mnt/vol1/share/Transfer/shelling-out/#{Etc.getlogin}".freeze

system "ssh #{USER}@#{HOST} 'mkdir -p #{REMOTE_DIR}'"
system "scp #{zip} #{USER}@#{HOST}:#{REMOTE_DIR}"
