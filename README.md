# deploy.sh

This is a simple bash script for deploying projects via scp to remote hosts.

## Installation

```
git clone https://github.com/stefanszymanski/deploy.sh
cd deploy.sh
make install
```

Per default the script is installed in `$HOME/.local/bin`.
If you want it to be installed in another directory use

```
make BINDIR=$HOME/another/directory install
```

There's also a zsh completion script.
The default directory `$HOME/.local/share/zsh/completion` can be changed with `ZSHCOMPDIR`.

```
make install-zsh-completion
# OR
make ZSHCOMPDIR=$HOME/somewhere/else install-zsh-completion
```

## Usage

```
Usage: deploy -t [TARGET] [FILE]...

A simple deploy script.

Examples:
  deploy -t dev src/adir    # deploy src/adir on dev
  deploy -t dev -sun        # deploy uncommited files on dev
  deploy -da                # deploy all files on the default target
  deploy -lv                # list availabe targets with additional information

Arguments:
  -t TARGET     target to deploy on
  -p DIR        project directory
                if omitted and in a git repository the repository root is used
                otherwise the current working directory
  -d            Use the default target
  -c FILE       targets configuration file
                if omitted .deploy.conf from the project directory is used
  -a            deploy all files
                when set all other file specifying arguments are ignored
  -v            be verbose
  -w            show warnings
  -D            dry run
  -l            list available targets
  -h            show this help

Arguments for git projects:
  -s            deploy staged files
  -u            deploy unstaged files
  -n            deploy new/untracked files
  -i            do not respect .gitignore
```

## Deployment

The specified files from the local-dir in the project root are packed into a
gzipped tarball, scp'd to the remote hosts /tmp directory and unpacked to
remote-dir.

## Remote host authentification

There are two options:

- `prompt` - the normal ssh command, that may prompt for a password or passphrase
- `pass` - an expect wrapper script for ssh, that reads a password from pass (https://www.passwordstore.org)

## Example configuration file

```
[servers]
# <name>  <host>              <auth-type>     <auth-data>
dev       user@host           pass            project/ssh/dev
stage     user@other-host     pass            project/ssh/stage
live      user@example.org    prompt

[targets]
# <name>  <server>            <local-dir>     <remote-dir>          <post-commands>
dev       dev                 src/public      /var/www/htdocs       rights-plugins
dev2      dev                 src/public      /var/www2/htdocs      rights-plugins
stage     stage               src/public      /var/www/htdocs       rights-plugins;rights-bin

[postcmd:rights-plugins]
# backslashes must be escaped!
find plugins -type d -exec chmod 775 {} \\;
find plugins -type f -exec chmod 644 {} \\;

[postcmd:rights-bin]
find bin -type f -exec chmod +x {} \\;

[default]
# a target name
dev

[branch:master:targets]
# each line is either a target name from section [targets] or target definition
dev
dev2
stage
live      live                src/public      /var/www/htdocs

[branch:devel:default]
# like section [default] but for a specific branch
dev2
```
