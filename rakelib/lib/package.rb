# frozen_string_literal: true

# Data class
#
# Attributes
#
#   :name          Home folder and the install task name
#   :repo          Github full repository name - "gh_user/gh_repo"
#   :archive       Github archive name with possible %s placeholder for version
#   :display_name  Display name
Package = Data.define(:name, :repo, :archive, :display_name) do
  include Rake::DSL

  class << self
    attr_reader :names

    def [](*)
      new(*).tap { Package.names << define_reader(_1) }
    end

    def define_reader(instance)
      define_singleton_method(instance.name) { instance }
    end

    # Set these only once.
    def directory(dir = nil) = @directory ||= Pathname.new(File.expand_path(dir))
    def task_args(args = nil) = @task_args ||= args
  end

  @names = []

  # Installer task
  def itask
    desc "Install the latest or provided version of #{display_name} from Github"
    task(name, self.class.task_args => :environment) do |_t, args|
      puts "* Installing #{display_name} #{args.version || "latest release"} ..."

      installer(args.version).install { yield _1, args }
    end
  end

  def installer(version) = Installer.new(release(version), install_dir)
  def release(version) = GithubRelease.new(repo, archive, version)
  def install_dir = self.class.directory.join(name.to_s)
end

class App < Package
  directory "~/Apps"
  task_args %i[version remove_previous_versions?]

  def itask
    super() do |ai, targs|
      ai.remove_previous_versions if targs.remove_previous_versions?

      # Enables switching installed versions.
      installed_version_file = ai.home_dir.join("INSTALLED_VERSION")
      installed_version = installed_version_file.read rescue ""
      ai.insist_install if installed_version != ai.version

      ai.upon_installation do
        yield ai
        installed_version_file.write ai.version
      end
    end
  end
end

class Font < Package
  directory "~/.local/share/fonts/"
  task_args [:version]

  def itask
    super() do |fi|
      fi.upon_installation do
        chdir(fi.extract_dir) { sh(yield) } if block_given?

        fi.remove_previous_versions!
        sh "fc-cache -f"
      end
    end
  end
end
