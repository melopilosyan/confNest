# frozen_string_literal: true

# Creates tasks with the following signiture.
#
# rake install:{package name}          # Install the latest version
# rake install:{package name}[0.9.0]   # Install 0.9.0 version
# rake install:{package name}[0.9.5,t] # Install 0.9.5 version and remove the 0.9.0
# rake install:{package name}[,t]      # Install the latest version and remove the previous one
#
# @param [Package] package
def register_package_installer(package, &)
  task package.name, %i[version remove_previous_version?] => :environment do |_t, args|
    puts "Installing #{package.display_name} ..."

    package.install args.version do |pi|
      pi.remove_previous_version! if args.remove_previous_version?
      yield pi, args
    end
  end
end

def register_font_installer(package, &)
  register_package_installer package do |fi, args|
    yield(fi) if block_given?

    # If asked to remove the previous version, fc-cache has to be run
    # even when installation is not required.
    if args.remove_previous_version?
      fi.leading_task!(:rebuild_font_cache) { sh "fc-cache -f" }
    else
      fi.upon_installation { sh "fc-cache -f" }
    end
  end
end

namespace :install do
  desc "Install the latest versions of all configured packages"
  task all: Package.names

  desc "Install the latest or provided version of Neovim from Github"
  register_package_installer Package.neovim do |nvim|
    installed_version_file = "#{nvim.home_dir}/INSTALLED_VERSION"

    # Enables switching installed versions
    installed_version = File.read(installed_version_file) rescue ""
    nvim.insist_install! if installed_version != nvim.version

    nvim.upon_installation do
      ln_sf "#{nvim.extract_dir}/bin/nvim", File.expand_path("~/.local/bin/nvim")
      File.write installed_version_file, nvim.version
    end
  end

  desc "Install the latest or provided version of NerdFontsSymbolsOnly from Github"
  register_font_installer Package.nerd_font

  desc "Install the latest or provided version of CascadiaCode font face from Github"
  register_font_installer Package.cascadia_code do |cc|
    cc.upon_installation do
      chdir cc.extract_dir do
        sh <<-BASH
          mv ttf/CascadiaCode.ttf ttf/CascadiaCodeItalic.ttf . &&
          rm -r ttf otf woff2
        BASH
      end
    end
  end

  desc "Install the latest or provided version of JetBrainsMono font face from Github"
  register_font_installer Package.jetbrains_mono do |jbm|
    jbm.upon_installation do
      chdir jbm.extract_dir do
        # Unlike bash, shell doesn't like comments and blank spaces after backslash (line continuation)
        sh <<-BASH.gsub(/(\\|\$d\s{3})(.+)$/, '\1')
          d=fonts/ttf && \\                                       # Set variable d = fonts/ttf
          find $d -type f ! -name "*NL*" -exec mv -t . {} + && \\ # Move files without "NL" in the name from d into current directory
          rm -r fonts || \\                                       # Remove fonts
          ! test -d $d                                            # Check if d is not a directory - hack to always exit with success
        BASH
      end
    end
  end
end
