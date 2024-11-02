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

  Pry.config.prompt_name = "installer"
  Pry.start
end

desc "console - Open IRB session in the installer context"
task i: :environment do
  require "irb"

  IRB.setup nil
  IRB.conf[:IRB_NAME] = "installer"
  IRB::Irb.new.run
end

task default: :c
