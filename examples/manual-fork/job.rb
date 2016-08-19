#!/usr/bin/env ruby

# Generate messages to random streams
(1..20).each do |index|
  stream = [$stdout, $stderr].sample
  stream.puts index
  stream.flush # Don't buffer the output
  sleep rand
end
