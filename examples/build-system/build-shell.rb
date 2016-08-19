#!/usr/bin/env ruby

require 'pathname'

in_path = Pathname.glob('*.c')[0]
out_path = in_path.sub_ext('')
zip_path = in_path.sub_ext('.zip')

# Compile source code
system "cc -o #{out_path} #{in_path}"

# Archive source and compiled program
system "zip #{zip_path} #{in_path} #{out_path}"

# Upload to atlas
USER = 'medora'.freeze
HOST = 'atlas'.freeze
REMOTE_DIR = "/mnt/vol1/share/Transfer/shelling-out/#{Etc.getlogin}".freeze

system "ssh #{USER}@#{HOST} 'mkdir -p #{REMOTE_DIR}'"
system "scp #{USER}@#{HOST} #{zip_path} #{REMOTE_DIR}"
