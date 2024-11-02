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
