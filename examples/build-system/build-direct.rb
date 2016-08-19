#!/usr/bin/env ruby

require 'pathname'
require 'zip'
require 'net/sftp'
require 'etc'

in_path = Pathname.glob('*.c')[0]
out_path = in_path.sub_ext('')
zip_path = in_path.sub_ext('.zip')

# Compile source code
system 'cc', '-o', out_path.to_s, in_path.to_s

# Archive source and compiled program
Zip::File.open(zip_path, Zip::File::CREATE) do |zip_file|
  [in_path, out_path].map(&:to_s).each do |path|
    zip_file.add(
      path, # Path to file
      path # Path in the zip file
    ) { true } # Should continue if the file exists?
  end
end

# Upload to atlas
REMOTE_DIR = "/mnt/vol1/share/Transfer/shelling-out/#{Etc.getlogin}".freeze

Net::Sftp.start('atlas', 'medora') do |sftp|
  sftp.mkdir! REMOTE_DIR
  sftp.upload! zip_file, "#{REMOTE_DIR}/#{zip_file}"
end
