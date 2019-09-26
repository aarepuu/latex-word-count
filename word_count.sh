#!/bin/bash
#
# This script traverses all commits of a git repository in the current directory
# and counts the number of words that are changed, i.e. added or deleted for all
# TeX files. The output contains a time-stamp (YYYY-MM-DD). Next, there are some
# counts, viz. the number of added, deleted, and total words.
#
# You can use `gnuplot`, for example, to create nice visualizations from the raw
# data. For this, it may be useful to specify the first column as a date column:
#
#   set xdata time
#   set timefmt "%Y-%m-%d"
#
# Following this, you may plot the desired information. Use 'branch' in order to
# control for which branch the commits are being enumerated.

today=`date +%F`
branch="master"

last_words=0
todays_words=0
daily_goal=500

#header
if [[ "$1" != "today" ]]; then
  echo date added deleted words
fi

for commit in $(git rev-list --reverse $branch)
do
  date=$(git show -s --format=%cd --date=short $commit)
  if [[ $date == $today && $last_words -eq 0 ]]; then
    last_words=$words
  fi
  added=$(git show -p --word-diff=porcelain $commit "*.tex" | grep -e '^+[^+]' | wc -w)
  deleted=$(git show -p --word-diff=porcelain $commit "*.tex" | grep -e '^-[^-]' | wc -w)

  words=$(($words+$added))
  words=$(($words-$deleted))

if [[ "$1" != "today" ]]; then
  echo $date $added $deleted $words
fi

done

if [[ "$1" = "today" ]]; then
  todays_words=$(($words-$last_words))
  echo "You have written $todays_words words today."
  if [[ $todays_words -gt $daily_goal ]]; then
    echo "Nice work, you have met your daily goal!"
  else
    echo "You need to write $(($daily_goal-$todays_words)) more words to meet your daily goal!"
  fi
fi
