# New domain!

From now on the exercises page is available here: [${labname}.trainings.nvtc.io]()

# Notice
The repository on Azure Devops is no longer in use for the release pipelines, the simplest way to continue work would be to clone this new repository here on Github and continue your work here.
An alternative is to change the origin of the git repository:

```bash
$ git remote rm origin
$ git remote add origin git@github.com:NovatecConsulting/developer-security-training-infrastructure.git
$ git config master.remote origin
$ git config master.merge refs/heads/master
```

Check that the origin is set up correctly with:

```bash
$ git remote -v
```

# Academy Infrastructure Repo
Set variables within the release pipeline creation step! 

# Creating a pull request using git rebase

We want to keep our commit history as clean and clear as possible which is why we want to do code integration with git rebase instead of git merge.

## Workflow
If you start working on a new feature/ticket go to your local master branch first:
```bash
$ git checkout master
```

Next, update the master with the newest changes:

```bash
$ git fetch origin master / git fetch --all
$ git rebase origin master
```

Create a new branch:

```bash
$ git checkout -b <newbranch> master
```

After finishing the work on the new branch it is time to rebase:

Rebasing allows to alter commits before pushing them to them to the repository via interactive rebasing against a branch, in this case master:

```bash
$ git rebase -i master
```

Or if the branch is already rebased against master (or another branch) you can rebase against the current HEAD:

```bash
$ git rebase -i HEAD~n
```

with n as the number of commits that need to be squashed or modified. This commands opens a text editor (usually nano or vim) where you can choose an action to perform on each individual commit.

Short explanations for the most useful commands: <br>
p or pick: Push commit as is<br>
r or reword: Push commit but change message<br>
s or squash: Meld commit into previous commit<br>
f or fixup: Meld commit into previous commit and discard log message of this commit

An example how you can integrate mutliple commits into one:

```
pick  33d5b7a Message for commit with some substantial work done in it #1
f 9480b3d Commit message with just a typo fix                          #2
pick  5c67e61 Commit message with more relevant work in it             #3
```

This way the second commit will be integrated into the first one, thus no longer cluttering up the history with uninteresting information. There are more commands you can use for interactive rebasing, but those are the ones you are probably going to use the most.

Changing the commit message in interactive rebase works as follows:

```
reword  33d5b7a different message for commit with some substantial work 
```

After squashing commits that are already pushed to the repository you might have to use force push, this is because you change the hash value of the commit and need to overwrite the value that is already stored there.

```bash
git push -f origin master
```

After the new branch is rebased and the commits are cleaned up you can push as usual.
