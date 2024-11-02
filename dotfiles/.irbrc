# frozen_string_literal: true

# It loads twice
return if defined?(IrbPrompt)

require "#{ENV.fetch "CONFIGS_DIR"}/ruby/repl_rc"

class IrbPrompt
  include ColorPromptHelpers

  def add(name = :COLORED)
    sep = p_sep
    context = scope("irb", "#{c_cwd}%m")
    prefix = env_segment(IRB.conf[:IRB_NAME] == "irb" ? nil : "%N")

    IRB.conf[:PROMPT][name] = {
      PROMPT_I: "#{prefix} #{context}#{c_info}:%i #{sep}",
      PROMPT_S: "#{prefix} #{context}#{c_info}:%i%l#{sep}",
      PROMPT_C: "#{prefix} #{context}#{c_info}:%i*#{sep}",
      RETURN: "#{output_prefix}%s\n",
    }
    IRB.conf[:PROMPT_MODE] = name
  end
end

module InitPromptAfterSetup
  def initialize(*)
    IrbPrompt.new.add
    super
  end
end
IRB::Irb.prepend InitPromptAfterSetup
