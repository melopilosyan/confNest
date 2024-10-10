# frozen_string_literal: true

# Download, extract and install packages/programs from the internet.
#
# It uses a chain of rake file tasks to conditionally execute missing steps.
#
# The installation step creates an \installed_txt file by default. Use the `upon_installation`
# method to define the actual installation for a particular package. To run the installation
# step regardless of whether it has been done, call the `insist_install` method. And use the
# +prepend_task+ to define a new task to execute after installation.
#
# Both `upon_installation` & `prepend_task` methods can be called as many times as needed,
# adding more actions and prepending more tasks to the chain respectively.
#
# Pseudo example:
#
#   Installer.new(...).install do |installer|
#     installer.insist_install if needed
#
#     installer.remove_previous_versions if has_to_be
#
#     installer.prepend_task(:task_name) do
#       # Define the task to run after installation
#     end
#
#     installer.upon_installation do
#       # Define the actual installation
#     end
#   end
#
# Creates the following directory structure (Neovim example):
#
# neovim                        | home_dir
# ├── 0.9.0                     | version_dir
# │   ├── installed             | installed_txt
# │   ├── nvim-linux64          | extract_dir
# │   └── nvim-linux64.tar.gz   | archive_path
# └── 0.9.5
#     ├── installed
#     ├── nvim-linux64
#     └── nvim-linux64.tar.gz
#
class Installer
  include Rake::DSL

  attr_reader :home_dir, :version_dir, :extract_dir, :archive_path, :installed_txt,
              :release

  # @param [Pathname] home_dir
  def initialize(release, home_dir)
    @release = release
    @home_dir = home_dir

    define_file_structure
    @install_task = @root_task = define_task_chain
  end

  def install
    yield(self) if block_given?

    @root_task.invoke
    print_report
  end

  def upon_installation(deps = nil, &block)
    @install_task.enhance(Array(deps)) if deps

    # Leaves the initial action last to mark the installation complete at the end.
    @install_task.actions.insert(-2, block) if block
  end

  def prepend_task(name, as: :task, &)
    # Since Rake tasks are global objects, they can collide during bulk invocations.
    uniq_name = "#{object_id}#{name}"
    @root_task = send(as, uniq_name => @root_task.name, &)
  end

  def insist_install
    # Adding a regular task as a dependency to a file task will invoke it regardless
    # of whether the file exists.
    task :do_install!
    upon_installation :do_install!
  end

  def remove_previous_versions
    prepend_task(:remove_previous) { remove_previous_versions! }
  end

  def print_report
    puts "#{@performed ? "I" : "Already i"}nstalled at #{version_dir}"
  end

  def remove_previous_versions!
    puts "Removing previous versions ..."
    sh "rm -rf $(command ls -d #{home_dir}/*/ | grep -v #{release.version})"
  end

  def version = release.version

  private

  def define_file_structure
    @version_dir = home_dir.join(release.version)

    @extract_dir = version_dir.join(release.file_basename)
    @archive_path = version_dir.join(release.archive_name)
    @installed_txt = version_dir.join("installed")
  end

  def define_task_chain
    directory version_dir
    file(archive_path => version_dir) { download }
    file(extract_dir => archive_path) { extract }
    file(installed_txt => extract_dir) { mark_complete }
  end

  def download
    sh "curl -sSJLO --output-dir #{version_dir} #{release.download_url}"
  end

  def mark_complete
    touch installed_txt
    @performed = true
  end

  # TODO: Extract out following methods into an Extractor
  def extract
    case release.file_ext
    when "zip" then unzip
    when "tar.gz" then untar_gz
    else halt! "Unknown archive. Cannot extract #{archive_path}"
    end
  end

  def unzip = sh("unzip -qd #{extract_dir} #{archive_path}")
  def untar_gz = sh("tar xzf #{archive_path} -C #{version_dir}")
end
