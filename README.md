# Ora::Cli

A command line tool to automate development workflow in ORA

## Installation

    $ gem install ora-cli
    $ ora-install

## Uninstallation

    $ ora-uninstall
    $ gem uninstall ora-cli

## Usage

    $ ora

1. Run `ora` command at the project folder
2. Fuzzy search (using [selecta](https://github.com/garybernhardt/selecta)) the task you want to run and type enter.

## Tasks

  `new_feature_branch`: Help to create a new branch from up-to-date develop branch

  `push_feature_branch`: Help to push your feature branch to remote ready for pull request

  `push_to_staging`: Help to push your feature branch to staging

  `push_to_uat`: Help to push your feature branch to uat

  `push_to_master`: Help to push your feature branch to develop and master branches with a version tag

  `switch_branch`: Help to switch branch without thinking about dirty files

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ducktyper/ora-cli.
