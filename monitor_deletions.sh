#!/bin/bash
# Find existing files in download/complete that are not in movies or tvshows and delete them.

# Define environment variables
export DOWNLOAD_MOVIE="download location"
export DOWNLOAD_SHOWS="download location"

export MOVIES_FOLDER="radarr folder"
export TVSHOWS_FOLDER="sonarr folder"

# Function to check for hardlinked files
findExistingFile() {
  local file="$1"
  # Check if the file has a hardlink in the target folders
  local linked_file
  linked_file=$(find "$MOVIES_FOLDER" "$TVSHOWS_FOLDER" -samefile "$file" 2>/dev/null)

  if [ -z "$linked_file" ]; then
    echo "File \"$file\" is not present in the movies or TV shows folders. Deleting..."
    rm -v "$file"
  fi
}

export -f findExistingFile

# Find and process files in DOWNLOAD_MOVIE
find "$DOWNLOAD_MOVIE" -type f -size +1G -exec bash -c 'findExistingFile "$0"' {} \;

# Find and process files in DOWNLOAD_SHOWS
find "$DOWNLOAD_SHOWS" -type f -size +1G -exec bash -c 'findExistingFile "$0"' {} \;
