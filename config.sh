#!/bin/bash

# Prompt for the media folder path
read -p "Enter the media folder path: " media_path

# Create the required folder structure
mkdir -p "$media_path/MOVIES/Downloads"
mkdir -p "$media_path/MOVIES/Movies"
mkdir -p "$media_path/TVSHOWS/Downloads"
mkdir -p "$media_path/TVSHOWS/TVShows"

echo "✅ Media folders created successfully at: $media_path"

# Prompt for PLEX_CLAIM
echo "To get a PLEX_CLAIM token, visit: https://plex.tv/claim"
read -p "Enter your PLEX_CLAIM token: " plex_claim

# Prompt for Filebrowser credentials
read -p "Enter Filebrowser ADMIN_USER: " filebrowser_user
read -sp "Enter Filebrowser ADMIN_PASSWORD: " filebrowser_password
echo ""

# Get the current working directory
root_dir="$PWD"

# Find all subfolders containing docker-compose.yml
find "$root_dir" -mindepth 1 -maxdepth 1 -type d | while read -r service_folder; do
    compose_file="$service_folder/docker-compose.yml"

    # Check if the docker-compose file exists
    if [ ! -f "$compose_file" ]; then
        echo "⚠️ Skipping $service_folder (no docker-compose.yml found)"
        continue
    fi

    # Determine the service name by checking the folder name
    service_name=$(basename "$service_folder")

    # Define volume paths for each service
    case "$service_name" in
        "plex" | "qbittorrent")
            new_volumes="      - $media_path:/media"
            ;;
        "radarr")
            new_volumes="      - $media_path/MOVIES/Movies:/data/MOVIES"
            ;;
        "sonarr")
            new_volumes="      - $media_path/TVSHOWS/TVShows:/data/TVSHOWS"
            ;;
        "filebrowser")
            new_env="      - ADMIN_USER=$filebrowser_user\n      - ADMIN_PASSWORD=$filebrowser_password"
            ;;
        *)
            echo "⚠️ Skipping $service_folder (not a targeted service: $service_name)"
            continue
            ;;
    esac

    echo "Processing: $compose_file"

    # Fix indentation and modify docker-compose files
    if [[ "$service_name" == "plex" ]]; then
        sed -i "s|PLEX_CLAIM=.*|PLEX_CLAIM=$plex_claim|" "$compose_file"
    fi

    if [[ "$service_name" == "filebrowser" ]]; then
        sed -i "/environment:/a$new_env" "$compose_file"
    fi

    if grep -q "volumes:" "$compose_file"; then
        sed -i "/volumes:/a\\$new_volumes" "$compose_file"
    else
        sed -i "/services:/a\  volumes:\n$new_volumes" "$compose_file"
    fi

    echo "✅ Updated: $compose_file"
done

echo "🚀 All docker-compose.yml files have been updated!"
