#!/bin/bash

# Check if the script has been ran before
if [ -e /tmp/firefox-profile-has-ran ]; then
    return 0
fi

# Create a marker file to indicate that the script has ran
touch /tmp/firefox-profile-has-ran

firefox-profile() {
    local default_profile default_release_profile youtube_profile

    # Find default-release and default profile
    default_release_profile=$(find ~/.mozilla/firefox -maxdepth 1 -type d -name '*.default-release' 2>/dev/null | head -n 1)
    default_profile=$(find ~/.mozilla/firefox -maxdepth 1 -type d -name '*.default' 2>/dev/null | head -n 1)
    
		# Remove the .default-release and default profile if it exists
    if [ -n "$default_release_profile" ]; then
        rm -r "$default_release_profile"
    fi

    if [ -n "$default_profile" ]; then
        rm -r "$default_profile"
    fi

    # Create a new profile named "youtube" if it doesn't exist
    youtube_profile=~/.mozilla/firefox/youtube-profile
    if [ ! -d "$youtube_profile" ]; then
        firefox -CreateProfile "youtube-profile $youtube_profile"
    fi

    # Create a new profile named "default" if it doesn't exist
    default_profile_new=~/.mozilla/firefox/default-profile
    if [ ! -d "$default_profile_new" ]; then
        firefox -CreateProfile "default-profile $default_profile_new"
    fi

		mkdir -p ~/.mozilla/firefox/default-profile/chrome/
		mkdir -p ~/.mozilla/firefox/youtube-profile/chrome/

		sudo cp ~/.config/firefox/userChrome.css ~/.mozilla/firefox/default-profile/chrome/
		sudo cp ~/.config/firefox/user.js ~/.mozilla/firefox/default-profile/chrome/
		sudo cp ~/.config/firefox/userChrome.css ~/.mozilla/firefox/youtube-profile/chrome/
		sudo cp ~/.config/firefox/user.js ~/.mozilla/firefox/youtube-profile/chrome/
}

firefox-profile
