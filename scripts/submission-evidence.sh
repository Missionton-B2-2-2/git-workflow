#!/bin/bash

# Issue
gh issue list --state all --limit 100 \
  --json number,title,author,assignees,state,url \
  --jq '.[] | [.number, .title, .author.login, .state, .url] | @tsv'

# Pull Requests
gh pr list --state all --limit 100 \
  --json number,title,author,state,mergedAt,url \
  --jq '.[] | [.number, .title, .author.login, .state, .mergedAt, .url] | @tsv'

# Review Comments
gh pr list --state all --limit 100 --json number \
  --jq '.[].number' | while read pr; do
    echo "========== PR #$pr =========="
    gh pr view "$pr" \
      --json title,author,reviews,comments \
      --jq '{
        title: .title,
        author: .author.login,
        reviews: [.reviews[] | {
          reviewer: .author.login,
          state: .state,
          body: .body
        }],
        comments: [.comments[] | {
          author: .author.login,
          body: .body
        }]
      }'
done


# History to File
{
  echo "===== ISSUES ====="
  gh issue list --state all --limit 100

  echo "===== PULL REQUESTS ====="
  gh pr list --state all --limit 100

  echo "===== GIT HISTORY ====="
  git log --oneline --graph --all
} > submission-evidence.txt