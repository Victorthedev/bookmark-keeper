#!/bin/bash

check_browser() {
    local browser_folder="$APPDATA/$1"

    if [ -d "$browser_folder" ]; then
        return 0
    else
        return 1
    fi
}

fetch_bookmarks() {
    local browser="$1"
    local bookmarks_file="$(find "$APPDATA/$browser" -type f -name "Bookmarks" 2>/dev/null)"

    if [ -n "$bookmarks_file" ]; then
        grep -Po '"url": "\K([^"]+)' "$bookmarks_file" | grep "$2"
    fi
}

append_to_markdown() {
    local output_file="$1"
    shift
    echo -e "\n\n### Bookmarks\n" >> "$output_file"
    echo "$@" >> "$output_file"
}

main() {
    keyword="$1"
    output_file="bookmarks.md"

    if check_browser "Google/Chrome/User Data"; then
        chrome_bookmarks=$(fetch_bookmarks "Google/Chrome/User Data" "$keyword")

        if [ -n "$chrome_bookmarks" ]; then
            append_to_markdown "$output_file" "Chrome Bookmarks:" "$chrome_bookmarks"
        fi
    fi

    
    if check_browser "BraveSoftware/Brave-Browser/User Data"; then
        brave_bookmarks=$(fetch_bookmarks "BraveSoftware/Brave-Browser/User Data" "$keyword")

        if [ -n "$brave_bookmarks" ]; then
            append_to_markdown "$output_file" "Brave Browser Bookmarks:" "$brave_bookmarks"
        fi
    fi

    
    if check_browser "Chromium/User Data"; then
        chromium_bookmarks=$(fetch_bookmarks "Chromium/User Data" "$keyword")

        if [ -n "$chromium_bookmarks" ]; then
            append_to_markdown "$output_file" "Chromium Bookmarks:" "$chromium_bookmarks"
        fi
    fi        
}

if [ -z "$1" ]; then
    echo "Usage: $0 <keyword>"
    exit 1
fi

main "$1"
