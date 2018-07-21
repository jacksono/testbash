#!/bin/bash
# Store arguments passed from the command line
args=("$@")

# Handles termination of the script either from the trap method or from completion of all operations
function doExit {
  echo "\nCleaning up & Exiting..."
  if [ -e STDOUT ]; then
    rm STDOUT
  fi

  if [[ -e STDERR && -s STDERR ]]; then
    echo "\nExited with an error. See error message below"
    echo "\nError Message"
    echo "*************"
    cat STDERR
    echo "*************"
    rm STDERR
  else
    echo "\nSuccesfully exited"
  fi
  return
}

# Handles adding new changes to the staging before they are committed. Also calls the doCommit function
function doStage {
  if [ -n "${args[1]}" ]; then
    stage=${args[1]}
  else
    echo -e "\nProceed to add all changes to staging? [y/Y or n/N]: \c"
    read stage
  fi

  until [[ $stage = "y"  ||  $stage = "Y" || $stage = "n"  ||  $stage = "N" ]]; do
    echo -e "\nInvalid option: \"$stage\". Please use[y/Y or n/N] or use [CTR + C to exit]: \c"
    read stage
  done


  if [[ $stage = "y"  ||  $stage = "Y" ]]; then
    echo "\nStaging all changes..."
    git add .
    echo "\nStaging Done"
    doCommit
    doExit
  else
    doExit
  fi
}

# Handles commiting of staged changes. Will prompt for a commit message in case it is not passed as the 2nd
# command line arg. Also calls the doPush function
function doCommit {
  if [ -n "${args[1]}" ]; then
    commit=${args[1]}
  else
    echo -e "\nProceed to commit all changes [y/Y or n/N]: \c"
    read commit
  fi

  until [[ $commit = "y"  ||  $commit = "Y" || $commit = "n"  ||  $commit = "N" ]]; do
    echo -e "\nInvalid option: \"$commit\". Please use[y/Y or n/N] or use [CTR + C to exit]: \c"
    read commit
  done

  if [[ $commit = "y"  ||  $commit = "Y" ]]; then
    if [[ -n "${args[2]}" ]]; then
      commitMsg=${args[2]}
    else
      echo -e "\nEnter commit mesage: \c"
      read commitMsg
    fi

    echo "\nCommitting changes..."
    git commit -m $commitMsg >STDOUT
    echo "\nCommiting Done"
    doPush
  else
    return
  fi
}

# Handles pushing of commited changes to the remote repo named origin. Will push to the currently checked out branch.
function doPush {
  if [[ -n "${args[1]}" ]]; then
    push=${args[1]}
  else
    echo -e "\nProceed to push changes? [y/Y or n/N]: \c"
    read push
  fi

  until [[ $push = "y"  ||  $push = "Y" || $push = "n"  ||  $push = "N" ]]; do
    echo -e "\nInvalid option: \"$push\". Please use[y/Y or n/N] or use [CTR + C to exit]: \c"
    read push
  done

  if [[ $push = "y"  ||  $push = "Y" ]]; then
    echo "\nPushing will be to origin"
    # echo -e "Enter branch name: \c"
    # read branch
    branch="$(git symbolic-ref --short -q HEAD)"

    echo "\nPushing changes to origin/$branch..."
    git push --porcelain origin $branch 2>STDERR 1>STDOUT
    if [ $? -eq 0 ]; then
      echo "\nPush Done"
    else
      echo "\nPush failed to complete.\n"
    fi
  else
    return
  fi
}

# Script begins to run from here by checking if there are any new changes to be staged or commited then calls the
# doStage function
if [ -n "$(git status --porcelain)" ]; then
  echo "Files with changes to be staged/commited:\n"
  git status --porcelain
  doStage
else
  echo "\nNo changes to stage/commit currently"
  doExit
fi
