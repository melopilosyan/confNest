cd $CONFIGS_DIR
rake install:jetbrains_mono || echo -e "\n>>> JetBrains font installation failed. Take a look. <<<\n"
rake install:cascadia_code || echo -e "\n>>> Cascadia font installation failed. Take a look. <<<\n"
rake install:nerd_font || echo -e "\n>>> Nerd font installation failed. Take a look. <<<\n"
cd -
