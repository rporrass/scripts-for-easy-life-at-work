# Scripts for an easy life at work
Some scripts to simplify my life at work

Most of them are made in Perl and can be used in the command line.

# Perl Scripts

* *git-clean* removes all branches in the local repository that are not at the master remote repository
* *git-start* creates a new branch in the local repository. The branch name should be passed as an argument to the script. All the spaces will be replaced by dash.
* *git-update* updates the current branch and the master with the latest from the remote repository.
* *git-upload* commit and push the changes in the current branch.
* *install-lib* get the latest from the remote repository and the run a *mvn clean install -DskipTests=true"
* *mvn-install* short cut for *mvn -U -settings settings.xml clean install -DskipTests=true*
* *mvn-package* shortcut for *mvn -U -settings settings.xml clean package -DskipTests=true*
* *mvn-test* shortcut for *mvn -U -settings settings.xml clean test*

## Requirements

* *script-commons.pl* should be at the same location than the Perl scripts

## How to install

Just copy them to a folder which is available from the command line and give them run permissions.
For windows users, I've use them with *cygwin*