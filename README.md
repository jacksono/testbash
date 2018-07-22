# Bash Script

A simple script to automate adding, committing and pushing of changes to a remote Github repo
Run it by calling it on the command line

```bash
. pushALL.sh
```

## Optional arguments
The script accepts 2 optional arguments
You can use the first argument to answer yes to all the prompts. For this to happen the 1st argument has to be y or Y
```bash
. pushALL.sh y
```
If you do not provide this argument then you will be prompted to type in a response of y/n at each step

The 2nd argument is the commit message that will be used when the `git commit` command is run.
To provide a more than one word for the commit message you should enclose them in quotes so that they can be treated as the
same argument.

```bash
. pushALL.sh y "Update the Readme"
```

If you do not provide this argument then you will be prompted to type a commit message into the command line when that
step is reached
