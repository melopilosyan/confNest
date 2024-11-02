# vi:ft=ruby:

# frozen_string_literal: true

require "date"
require "json"
require "yaml"

require "#{ENV.fetch "CONFIGS_DIR"}/ruby/repl_rc"

begin
  require "pry-doc"
rescue LoadError
  # Oops
end

class PryPrompt
  include ColorPromptHelpers

  def add(name = "colored", description = "Prompt")
    Pry.prompt = Pry::Prompt.new(name, description, [builder(p_sep), builder(s_sep)])
    Pry.config.output_prefix = output_prefix
  end

  def builder(sep)
    prompt = context = nil
    @prefix ||= env_segment((name = Pry.config.prompt_name) == "pry" ? nil : name)

    proc do |ctx, nesting, _pry_instance|
      next prompt if context == ctx

      context = ctx
      ctx = Pry.view_clip(ctx)
      connest = nesting.zero? ? c_cwd(ctx) : "#{c_cwd}#{ctx}#{c_info}:#{nesting}"
      prompt = "#{@prefix} #{scope "pry", connest} #{sep}"
    end
  end
end

PryPrompt.new.add

##### Helper methods #####

if defined?(ActiveRecord::Base)
  def query_db(sql)
    ActiveRecord::Base.connection.execute(sql).to_a
  end
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
