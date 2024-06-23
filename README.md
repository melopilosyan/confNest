# Omakub

Turn a fresh Ubuntu installation into a fully-configured, beautiful, and modern web development system by running a single command. That's the one-line pitch for Omakub. No need to write bespoke configs for every essential tool just to get started or to be up on all the latest command-line tools. Omakub is an opinionated take on what Linux can be at its best.

## Installation

```bash
wget -qO- https://raw.githubusercontent.com/melopilosyan/omakub/master/install.sh | bash
```

Optionally set custom install directories for Omakub and [configs](https://github.com/melopilosyan/configs)
via `DEST` and `CONFIGS_DIR` environment variables.

```bash
wget ... | DEST=custom/omakub/dir CONFIGS_DIR=custom/configs/dir bash
```

## License

Omakub is released under the [MIT License](https://opensource.org/licenses/MIT).
