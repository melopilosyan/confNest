# frozen_string_literal: true

$LOAD_PATH.prepend File.expand_path("rakelib/lib")

require "pathname"
require "package"

task :environment do
  require "utils"
  require "installer"
  require "github_release"
end

desc "console - Open Pry session in the installer context"
task c: :environment do
  require "pry"
  Pry.start
end

task default: :c
