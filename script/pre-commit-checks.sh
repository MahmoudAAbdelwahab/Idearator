#!/bin/sh

# Version: 0.3
# Author: Mina Nagy
# Email:  mnzaki [at] the gmail server

# This script is experimental! No warranties and stuff.

# Settings
# Note: all patterns must be GNU grep extended regexps

# If you want to allow non-ascii filenames set this variable to true.
allow_non_ascii=$(git config hooks.allownonascii)

# Merging
merge_artifacts=('<{6}' '={6}' '>{6}' '\|{6}')
merge_help_url="https://github.com/DevYah/coolsoft-13/wiki/Git-CheatSheet#merging"

# Lint
use_rubocop="no"

# Check for whitespace errors
check_whitespaces="yes"
autofix_whitespaces="yes"
spaces_per_tab="  "

# Colors
color_bad_file="\033[31m"
color_error_msg="\033[31;1m"
color_url="\033[34m"

############################## End of Settings #################################
######################## Don't mess with anything below ########################
################################## Please? #####################################

color_reset="\033[0m"
basedir=$(dirname $0)

function list_changed_files {
  git diff-index --cached --name-only --diff-filter=AM $against --
}

function echo_bad_file {
  echo -e $color_bad_file$1$color_reset
}
function echo_error_msg {
  echo -e $color_error_msg$1$color_reset
}
function echo_url {
  echo -e $color_url$1$color_reset
}

if git rev-parse --verify HEAD >/dev/null 2>&1
then
  against=HEAD
else
  # Initial commit: diff against an empty tree object
  against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
fi

# Redirect output to stderr.
exec 1>&2

# Check for Non ASCII filenames
if [ "$allow_non_ascii" != "true" ] &&
  test $(git diff --cached --name-only --diff-filter=A -z $against |
    LC_ALL=C tr -d '[ -~]\0' | wc -c) != 0
then
  echo_error_msg "Error: Attempt to add a non-ascii file name."
  echo
  echo "Are you adding a file with an Arabic filename?"
  echo "Don't."
  echo "Rename the file: git mv OldFileName NewFileName"
  echo "And try again."
  exit 1
fi

# Check for whitespace errors
if [[ "$check_whitespaces" == "yes" ]] && ! git diff-index --color --check --cached $against --; then

  echo
  echo_error_msg "Error: You left random whitespaces laying around! Look at the above messages!"

  if [[ "$autofix_whitespaces" == "yes" ]]; then
    echo "I'm going to try and fix some of them for you automagically, bas mata3melhash tani"

    FILE_LIST=$(git diff-index --check --cached $against -- | sed '/^[+-]/d' | sed -r 's/:[0-9]+:.*//' | uniq)
    for FILE in $FILE_LIST; do
      perl -i -wpe 's/\r\n/\n/g;s/\ *$//;s/\t/'"$spaces_per_tab"'/g;' "$FILE"
      perl -i -we 'local $/;local $_=<>;s/(\r?\n)*$//; print' "$FILE"
    done

    echo
    echo "Add these files and try to commit again!"

    for FILE in $FILE_LIST; do
      echo "  " $(echo_bad_file $FILE)
    done
  fi

  exit 1
fi

for f in list_changed_files; do

  # Check for merge artifacts
  if [[ "${merge_artifacts[*]}" != "" ]] &&
     (git diff --cached --diff-filter=AM -z $against -- $f |
      grep -E "$(IFS="|" ; echo "${merge_artifacts[*]}")" -q)
  then
    echo_error_msg "Error: Attempt to add an improperly merged file."
    echo
    echo "Looks like you didn't really resolve the conflict in:"
    echo_bad_file $f
    echo
    echo "There are merge artifacts in" $(echo_bad_file $f)
    git diff --color --cached --diff-filter=AM -z $against -- $f |
      grep --context=4 -E "$(IFS="|" ; echo "${merge_artifacts[*]}")"
    echo
    echo "Perhaps you want to read up on merging:"
    echo_url $merge_help_url
    echo
    echo "Fix" $(echo_bad_file $f) "and re-add it and try again."
    exit 1
  fi

  # Check code style
  if [[ "${use_rubocop}" == "yes" ]] && (echo "$f" | grep -E -q "*(rb|erb)") &&
    ! rubocop -c $basedir/../rubocop.yml -s $f
  then
    echo
    echo_error_msg "Error: Bad code style. See the above messages."
    echo "Fix" $(echo_bad_file $f) "and re-add it and try again."
    exit 1
  fi

done
