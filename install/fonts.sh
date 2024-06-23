cd $CONFIGS_DIR
rake install:jetbrains_mono
rake install:cascadia_code
rake install:nerd_font
cd -

fc-cache -f
