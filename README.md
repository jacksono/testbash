# Bash Script

A simple script to automate adding, committing and pushing of changes to a remote Github repo
Run it by calling it on the command line

```bash
. pushAll.sh
```

## Optional arguments
The script accepts 2 optional arguments
You can use the first argument to answer yes to all the prompts. For this to happen the 1st argument has to be y or Y
```bash
. pushAll.sh y
```
This will automatically stage all changes and proceed to commit and push them without any further prompts.

If you do not provide this first argument then you will be prompted to type in a response of y/n at each step

The 2nd argument is the commit message that will be used when the `git commit` command is run.
To provide more than one word for the commit message you should enclose them in quotes so that they can be treated as the
same argument.

```bash
. pushAll.sh y "Update the Readme"
```

If you do not provide this second argument then you will be prompted to type a commit message into the command line when that
step is reached.

## Selecting changes to be staged.
If you run the script without providing any arguments at the command line then you will have the option to select which of the changes to be staged.
A change may be a modification of an existing file or addition of a new file.
For each of the changes you will be prompted to select whether or not that change should be committed.
If you select y / Y, then that change will be staged. Selecting n / N at the prompt will not stage that particular change.

```bash
git add package.json?...y
git add test/test_helper.rb?...n
git add file.txt?...y
```
