cd "$CONFIGS_DIR" || return
rake install:jetbrains_mono[,t] || echo -e "\n>>> JetBrains font installation failed. Take a look. <<<\n"
rake install:cascadia_code[,t] || echo -e "\n>>> Cascadia font installation failed. Take a look. <<<\n"
rake install:nerd_font[,t] || echo -e "\n>>> Nerd font installation failed. Take a look. <<<\n"
cd - || return
