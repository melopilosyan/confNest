# Prepare local bin folder
mkdir -p ~/.local/bin

# Prepare local bash completions folder
mkdir -p ~/.local/share/bash-completion/completions

# Prepare local man folder
mkdir -p ~/.local/share/man/man1

# Extensions installer requires ~/.local/bin in the PATH.
if [[ $PATH != *~/.local/bin* ]]; then PATH="$HOME/.local/bin:$PATH"; fi

# Make functions available during initial installation.
source "$CONFIGS_DIR/bash/functions.sh"
