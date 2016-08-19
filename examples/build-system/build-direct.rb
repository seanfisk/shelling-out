#!/usr/bin/env ruby

require 'pathname'
require 'zip'
require 'net/sftp'
require 'etc'

input_path = Pathname.glob('*.c')[0]
input = input_path.to_s
output = input_path.sub_ext('').to_s
zip = input_path.sub_ext('.zip').to_s

# Compile source code
system 'cc', '-o', output, input

# Archive source and compiled program
Zip::File.open(zip, Zip::File::CREATE) do |zip_file|
  [input, output].map(&:to_s).each do |path|
    zip_file.add(
      path, # Path to file
      path # Path in the zip file
    ) { true } # Should continue if the file exists?
  end
end

# Upload to atlas
REMOTE_DIR = Pathname.new("/mnt/vol1/share/Transfer/shelling-out/#{Etc.getlogin}").freeze

Net::SFTP.start('atlas', 'medora') do |sftp|
  begin
    sftp.mkdir! REMOTE_DIR
  rescue Net::SFTP::StatusException
  end
  sftp.upload! zip, "#{REMOTE_DIR}/#{zip}"
end
