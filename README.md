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

  `new_feature_branch`: Create a new branch from up-to-date develop branch

  `push_feature_branch`: Push current feature branch to remote ready for pull request

  `delete_feature_branch`: Delete current feature branch

  `push_to_staging`: Push current feature branch to staging

  `push_to_uat`: Push current feature branch to uat

  `push_to_master`: Push develop to master with a version tag with a message including all new pull requests from the previous tag

  `switch_branch`: Switch branch without thinking about dirty files

## Custom develop branch

    $ ora branch-name

You can parse a branch name to ora command to use it instead develop branch.
Useful when we need a second develop branch.

> push_to_master will still push from develop to master.

## Error handling

    $ ora

When a task is failed, you can resolve the issue and run `ora` again to continue.
Ora-cli uses a file `~/ora_continue` to save the state when a task is failed.

> To continue failed task with custom develop branch, you need to type the branch name as an argument.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ducktyper/ora-cli.
