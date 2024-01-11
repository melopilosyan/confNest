# vi:ft=ruby:

# frozen_string_literal: true

require "date"
require "json"
require "yaml"

begin
  require "pry-doc"
rescue LoadError
  # Oops
end

# See .custom_prompt for exported colors and separators
module ColorPrompt
  COLORS = Hash.new { |h, k| h[k] = shell_to_ruby(k) }

  class << self
    def add(name, description = "Prompt")
      Pry::Prompt.add(name, description, separators) { |*args| format(*args) }
    end

    def separators
      primary_separator = dye(ENV.fetch("primary_prompt_separator"), :c_separator)

      [primary_separator, secondary_separator]
    end

    def secondary_separator
      @secondary_separator ||= dye(ENV.fetch("secondary_prompt_separator"), :c_separator)
    end

    def format(context, nesting, _pry_instance, separator)
      return separator if separator == secondary_separator

      time = dye(Time.new.strftime("%H:%M:%S"), :c_inactive)
      context = dye(Pry.view_clip(context), :c_cwd)
      nesting = nesting.nonzero? && dye(":#{nesting}", :c_info)

      "#{rails_env}#{ruby_version} #{time} #{context}#{nesting} #{separator}"
    end

    def ruby_version
      @ruby_version ||= dye(RUBY_VERSION, :c_ruby)
    end

    def rails_env
      @rails_env ||= defined?(Rails) ? dye("#{Rails.env.upcase} ", :c_err_code) : ""
    end

    def dye(str, color)
      "#{COLORS[color]}#{str}#{COLORS[:c_clear]}"
    end

    private

    # i.e., converts "\\[\\e[38;5;124m\\]" into "\e[38;5;124m"
    def shell_to_ruby(color)
      ENV[color.to_s].gsub(/\\[\[\]]/, "").gsub('\e', "\e")
    end
  end
end

ColorPrompt.add "colored"
Pry.prompt = Pry::Prompt["colored"]

# Pry.config.print = proc { |output, value| output.puts "decorated #{value}" }
Pry.config.output_prefix = ColorPrompt.dye("󰶻 ", :c_info)

##### Helper methods #####

if defined?(ActiveRecord::Base)
  def sql(query)
    ActiveRecord::Base.connection.execute(query).to_a
  end
end

def print_duration(run_count = 1, print_each: false)
  results = Array.new run_count
  start_time = Process.clock_gettime Process::CLOCK_MONOTONIC

  run_count.times do |i|
    start = Process.clock_gettime Process::CLOCK_MONOTONIC
    yield
    results[i] = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start

    puts results.last.round(9) if print_each
  end

  total = results.sum
  runtime = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time
  puts "Average: #{(total / results.size).round 9}\nTotal:   #{total.round 9}\nRuntime: #{runtime.round 9}"
end
