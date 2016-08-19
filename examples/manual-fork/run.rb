#!/usr/bin/env ruby

child_pid = fork do
  # Executing in child
  exec './job.rb'
end

puts "Child started with PID #{child_pid}"

_, status = Process.wait2(child_pid)
puts "Process exited with status #{status.exitstatus}"
