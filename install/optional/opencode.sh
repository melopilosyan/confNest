# https://opencode.ai/
# plugin: https://github.com/DietrichGebert/ponytail

curl -fsSL https://opencode.ai/install | bash


cat <<JSON > ~/.config/opencode/opencode.jsonc
{
  "\$schema": "https://opencode.ai/config.json",
  "plugin": [
    "@dietrichgebert/ponytail",
  ],
}
JSON

cat <<JSON > ~/.config/opencode/tui.jsonc
{
  "\$schema": "https://opencode.ai/tui.json",
  "theme": "nord",
}
JSON

# Save bash completion
opencode completion > ~/.local/share/bash-completion/completions/opencode

# Save bash completion for the oc alias
cat <<BASH > ~/.local/share/bash-completion/completions/oc
. ~/.local/share/bash-completion/completions/opencode
complete -o bashdefault -o default -F _opencode_yargs_completions oc
BASH
