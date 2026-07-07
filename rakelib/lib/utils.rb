# frozen_string_literal: true

require "open3"

def sh_out(cmd)
  puts cmd
  out, err, status = Open3.capture3 cmd

  halt!("Command failed with status (#{status.exitstatus})\n#{err}") unless status.success?

  out.chomp
end

def halt!(message)
  warn message
  exit 1
end

def local_bin(exe)
  File.expand_path("~/.local/bin/#{exe}")
end

def cache(name, &)
  path = Pathname.new("/tmp").join(name)

  # If modified less then an hour ago
  return path.read if path.exist? && Time.now - path.mtime < 3600

  yield.tap { path.write it }
end
