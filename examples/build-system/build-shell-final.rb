#!/usr/bin/env ruby

require 'pathname'
require 'shellwords'

in_path = Pathname.glob('*.c')[0]
out_path = in_path.sub_ext('')
zip_path = in_path.sub_ext('.zip')

# Compile source code
system "cc -o #{Shellwords.escape(out_path)} #{Shellwords.escape(in_path)}"

# Archive source and compiled program
system "zip #{Shellwords.escape(zip_path)} #{Shellwords.escape(in_path)} #{Shellwords.escape(out_path)}"
