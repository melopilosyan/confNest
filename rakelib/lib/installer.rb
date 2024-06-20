# frozen_string_literal: true

require "utils"

# Downloads, extracts and installs packages (GitHub released archives).
#
# The installation step is a Rake file task, creating an \installed file by default.
# Use the +upon_installation+ method to assemble the actual installation steps.
#
# To run the installation step regardless of whether it has been done before, call the
# +insist_install!+ method. And if there has to be a new task running after installation,
# add it via +leading_task!+.
#
#   installer = Installer.new(...) do |i|
#     # Preparation area
#     needed = {determine}
#     i.insist_install! if needed
#
#     i.leading_task!(:after_install_step) do
#       # After install area
#     end
#
#     i.upon_installation do
#       # Actual installation area
#     end
#   end
#
#   installer.install
#
# Creates the following directory structure (Neovim's example):
#
# neovim                        | home_dir
# ├── 0.9.0                     | version_dir
# │   ├── installed.txt         | installed
# │   ├── nvim-linux64          | extract_dir
# │   └── nvim-linux64.tar.gz   | archive_path
# └── 0.9.5
#     ├── installed.txt
#     ├── nvim-linux64
#     └── nvim-linux64.tar.gz
#
class Installer
  include Rake::DSL

  attr_reader :home_dir, :version_dir, :extract_dir, :archive_path, :installed, :release

  def initialize(name, dir, release)
    @release = release
    assign_attributes name, dir
    setup_tasks

    yield(self) if block_given?
  end

  def install
    leading_task.invoke
    puts "Installed at #{version_dir}"
  end

  def remove_previous_version!
    puts "Removing previous versions ..."
    chdir(home_dir) { sh "rm -r $(\\ls -d */ | grep -v #{release.version})" }
  end

  def insist_install!
    task :do_install!
    upon_installation :do_install!
  end

  def leading_task!(name, as: :task, &)
    @leading_task = send(as, name => leading_task.name, &)
  end

  def upon_installation(deps = nil, &block)
    install_task.enhance(Array(deps)) if deps
    install_task.actions.insert(-2, block) if block # Keep the initial action at the last spot
  end

  def version = release.version

  private

  attr_reader :leading_task, :install_task

  def setup_tasks
    directory version_dir
    setup_download_task
    file(extract_dir => archive_path) { extract }
    @install_task = file(installed => extract_dir) { touch installed }

    @leading_task = @install_task
  end

  def setup_download_task
    file archive_path => version_dir do
      sh "curl", "-sSJLO", "--output-dir", version_dir, release.download_url
    end
  end

  def assign_attributes(name, dir)
    @home_dir = File.expand_path("#{dir}/#{name}")

    @version_dir = "#{home_dir}/#{release.version}"
    @extract_dir = "#{version_dir}/#{release.file_basename}"
    @archive_path = "#{version_dir}/#{release.archive_name}"
    @installed = "#{version_dir}/installed"
  end

  # TODO: Extract out following methods into an Extractor
  def extract
    case release.file_ext
    when "zip" then unzip
    when "tar.gz" then untar_gz
    else halt! "Unknown archive. Cannot extract #{archive_path}"
    end
  end

  def unzip = sh("unzip", "-qd", extract_dir, archive_path)
  def untar_gz = sh("tar", "xzf", archive_path, "-C", version_dir)
end
