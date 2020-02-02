# deploy.sh

This is a simple bash script for deploying projects via scp to remote hosts.

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

Currently only password based authentification is supported. The password is
read from pass (https://www.passwordstore.org).

## Example configuration file

```
[servers]
# <name>  <host>              <auth-type>     <auth-data>
dev       user@host           pass            project/ssh/dev
stage     user@other-host     pass            project/ssh/stage
live      user@example.org    pass            project/ssh/live

[targets]
# <name>  <server>            <local-dir>     <remote-dir>
dev       dev                 src/public      /var/www/htdocs
dev2      dev                 src/public      /var/www2/htdocs
stage     stage               src/public      /var/www/htdocs

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
