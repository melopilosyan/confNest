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

  def self.from_rgb(rgb_color, str = nil)
    hex_to_dec = rgb_color.delete_prefix("#").scan(/../).map { _1.to_i(16) }
    "\e[38;2;#{hex_to_dec.join(";")}m#{str}"
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

##### Helper methods #####

if defined?(ActiveRecord::Base)
  def query_db(sql)
    ActiveRecord::Base.connection.execute(sql).to_a
  end
end

def allocated_objects
  initial = GC.stat(:total_allocated_objects)
  yield
  GC.stat(:total_allocated_objects) - initial
end

def simple_benchmark(run_count = 1, print_all: false, unit: :float_millisecond)
  results = Array.new(run_count)
  start_time = clock_time(unit)

  run_count.times do |i|
    start = clock_time(unit)
    yield
    results[i] = clock_time(unit) - start
  end

  runtime = clock_time(unit) - start_time
  total = results.sum

  puts results.pretty_inspect, nil if print_all

  fmt = "Average: %<average>.9f ms\nTotal:   %<total>.9f ms\nRuntime: %<runtime>.9f ms"
  { average: total / results.size, total:, runtime: }.tap { puts format(fmt, _1) }
end

def clock_time(unit = :float_millisecond)
  Process.clock_gettime(Process::CLOCK_MONOTONIC, unit)
end
