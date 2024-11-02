# frozen_string_literal: true

module Ansi
  module Colors
    def method_missing(symbol, *args) # rubocop:disable Style/MissingRespondToMissing
      @colors ||= Ansi.colors

      define_singleton_method(symbol) do |str = nil|
        str ? "#{@colors[symbol]}#{str}" : @colors[symbol]
      end

      public_send symbol, args.first
    end
  end

  def self.colors
    Hash.new { |h, k| h[k] = shell_to_ruby(k.to_s) }.update(
      red: "\e[31m",
      blue: "\e[34m",
      c_app_name: "\e[38;5;60m"
    )
  end

  # Converts colors "\\[\\e[38;5;124m\\]" into "\e[38;5;124m". See bash/rc.d/prompt.sh
  def self.shell_to_ruby(env_name)
    ENV.fetch(env_name).gsub(/\\[\[\]]/, "").gsub('\e', "\e")
  end
end

module ColorPromptHelpers
  include Ansi::Colors

  def env_segment(prompt_name)
    app = defined?(Rails) ? rails_segment : prompt_name && " #{c_app_name}#{prompt_name}"
    app ? "#{c_ruby}#{RUBY_VERSION}#{app}" : c_ruby(RUBY_VERSION)
  end

  def rails_segment
    env = case Rails.env
          when "development" then "#{blue}dev"
          when "production"  then "#{red}prod"
          else
            blue Rails.env
          end

    "#{c_info}ˈ#{c_ruby}#{Rails.version} #{scope Rails.root.basename, env}"
  end

  def scope(name, arg) = "#{c_app_name}#{name}(#{arg}#{c_app_name})"

  def p_sep = Ansi.shell_to_ruby("c_psep")
  def s_sep = Ansi.shell_to_ruby("c_ssep")
  def output_prefix = "#{c_info}󰶻 #{c_clear}"
end
