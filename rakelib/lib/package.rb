# frozen_string_literal: true

FileStructure = Data.define(
  :home_dir, :installed_version_txt, :version_dir, :extract_dir, :archive_path, :installed_txt
) do
  class << self
    def for(home_dir, release = nil)
      new(
        home_dir,                                                # home_dir
        home_dir.join("INSTALLED_VERSION"),                      # installed_version_txt
        release && version_dir = home_dir.join(release.version), # version_dir
        release && version_dir.join(release.file_basename),      # extract_dir
        release && version_dir.join(release.archive_name),       # archive_path
        release && version_dir.join("installed")                 # installed_txt
      )
    end
  end

  def installed_version = installed_version_txt.read rescue ""
end

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
      Package.define_singleton_method(instance.name) { instance }
    end
    private :define_reader

    # Set these only once.
    def directory(dir = nil) = @directory ||= Pathname.new(File.expand_path(dir))
    def task_args(args = nil) = @task_args ||= args

    def each(&)
      Package.names.each { yield Package.public_send(it) }
    end
  end

  @names = []

  # Installer task
  def itask
    desc "Install the latest or provided version of #{display_name} from Github"
    task(name, self.class.task_args => :environment) do |_t, args|
      puts "🚀 Installing #{display_name} #{args.version || "latest release"} ..."

      installer(args.version).install { yield _1, args }
    end
  end

  # Checker task
  def ctask
    desc "Check #{display_name} for updates"
    task(name => :environment) do
      puts "⭐ Latest version: #{release.version}"
      puts "📦 Installed version: #{fs.installed_version}"
    end
  end

  def installer(version) = Installer.new(r = release(args.version), fs(r))
  def release(version = nil) = GithubRelease.new(repo, archive, version)
  def fs(release = nil) = FileStructure.for(self.class.directory.join(name.to_s), release)
end

class App < Package
  directory "~/Apps"
  task_args %i[version remove_previous_versions?]

  def itask
    super() do |ai, targs|
      ai.remove_previous_versions if targs.remove_previous_versions?

      ai.enables_switching_installed_versions
      ai.upon_installation { yield ai }
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
