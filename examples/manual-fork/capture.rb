#!/usr/bin/env ruby

require 'pp'

pipes = %i(out err).map { |key| [key, %i(read write).zip(IO.pipe).to_h] }.to_h
pp pipes

child_pid = fork do
  # Executing in child
  pipes.each do |name, pipe|
    pipe[:read].close
    # Re-open stream as write ends of the pipe (dup2)
    eval("$std#{name}").reopen(pipe[:write])
  end
  exec './job.rb'
end

puts "Child started with PID #{child_pid}"

# Executing in parent
# Close the write ends of the pipe
pipes.each_value do |pipe|
  pipe[:write].close
end

# Collect the output
def reap(pipes, name)
  pipes[name][:read].each_line do |line|
    puts "#{name}: #{line}"
  end
end

thread = Thread.new { reap(pipes, :err) }
reap(pipes, :out)
thread.join

_, status = Process.wait2(child_pid)
puts "Process exited with status #{status.exitstatus}"
