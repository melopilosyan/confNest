# frozen_string_literal: true

$LOAD_PATH.prepend File.expand_path("rakelib/lib")

require "package"

task :environment do
  require "installer"
  require "github_release"
end

desc "console - Open Pry session in installer's context"
task c: :environment do
  require "pry"
  Pry.start
end

task default: :c
