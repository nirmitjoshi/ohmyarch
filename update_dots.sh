#!/bin/bash

# This is a personal script and won't run for you
# Its a Script to commit and push changes to Github repo
# Then to run stow to make changes locally

echo -e "Installing github-cli if needed..."
sudo pacman -S --needed --noconfirm github-cli

echo -e "Authenticating github-cli if needed..."
if ! gh auth status &> /dev/null; then
    echo -e "\n Please authenticate github-cli first!"
    gh auth login
else
    echo -e "\nGitHub CLI (gh) is already authenticated."
fi

# Authenticate Git
gh auth setup-git

# Get the current date and format it as "dd mmm yyyy"
current_date=$(date '+%d %b %Y')

# Get the current time
current_time=$(date '+%I:%M %p')

# Combine date and time with the "Update:" prefix
commit_message_default="Update: $current_date $current_time"
read -p "Enter Commit Message: " commit_message

# Commit the changes with the generated message
echo -e "Commiting changes..."
git add .

if [ -z "$commit_message" ]; then
  git commit -m "$commit_message_default"
else
  git commit -m "$commit_message"
fi

# Pushing changes
echo -e "\nPushing changes..."
git push origin main

# Running Stow
echo -e "\nRunning Stow..."
stow .

echo -e "\n\nUpdating Completed!"
