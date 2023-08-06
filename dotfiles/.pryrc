# vi:ft=ruby:

# frozen_string_literal: true

require "date"
require "json"
require "yaml"

# Removes +\[+ and +\]+ bits from shell formatted color codes
# and converts literal +\e+ to Unicode "\e" character.
def shell_to_ruby(color)
  ENV[color.to_s].gsub(/\\[\[\]]/, "").gsub('\e', "\e")
end

ENV_COLORS = Hash.new { |h, k| h[k] = shell_to_ruby(k) }
Colored = ->(text, color) { "#{ENV_COLORS[color]}#{text}#{ENV_COLORS[:c_clear]}" }

PRIMARY_SEPARATOR = Colored["󰞷 ", :c_console_icon]
SECONDARY_SEPARATOR = Colored[" ", :c_console_icon]
RAILS_ENV_COLORED = defined?(Rails) ? "#{Colored[Rails.env.upcase, :c_err_code]} " : ""

Pry::Prompt.add(
  "ruby-version",
  "Colored, with Ruby version and Rails environment name if present",
  [PRIMARY_SEPARATOR, SECONDARY_SEPARATOR]
) do |context, nesting, pry_instance, separator|
  if separator == SECONDARY_SEPARATOR
    separator
  else
    format "%<rails_env>s%<ruby_version>s %<in_count>s %<context>s%<nesting>s %<separator>s",
           rails_env: RAILS_ENV_COLORED,
           ruby_version: Colored[RUBY_VERSION, :c_ruby],
           in_count: Colored[pry_instance.input_ring.count, :c_inactive],
           context: Colored[Pry.view_clip(context), :c_cwd],
           nesting: nesting.positive? ? Colored[":#{nesting}", :c_info] : "",
           separator: separator
  end
end

Pry.prompt = Pry::Prompt["ruby-version"]

# Pry.config.print = proc { |output, value| output.puts "#{Colored['󰶻 ', :c_info]}#{value}" }
Pry.config.output_prefix = Colored["󰶻 ", :c_info]

Pry.commands.alias_command "sh", "show-method"
Pry.commands.alias_command "q", "exit"

begin
  require "pry-doc"
rescue LoadError
  puts "#{SECONDARY_SEPARATOR}gem install pry-doc"
end
