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

# Prompt for GPU type
echo "Select your GPU type for Plex hardware acceleration:"
echo "1) Intel/AMD (QuickSync/VAAPI)"
echo "2) NVIDIA (NVENC)"
read -p "Enter 1 or 2: " gpu_choice

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

    echo "Processing: $compose_file"

    if [[ "$service_name" == "plex" ]]; then
        cat > "$compose_file" <<EOL
version: '3.8'
services:
  plex:
    image: lscr.io/linuxserver/plex:latest
    container_name: plex
    network_mode: host
    environment:
      - PUID=0
      - PGID=0
      - TZ=Europe/Bucharest
      - VERSION=docker
      - PLEX_CLAIM=$plex_claim
EOL
        if [[ "$gpu_choice" == "1" ]]; then
            echo "      - /dev/dri:/dev/dri" >> "$compose_file"
        elif [[ "$gpu_choice" == "2" ]]; then
            cat >> "$compose_file" <<EOL
      - NVIDIA_VISIBLE_DEVICES=all
      - NVIDIA_DRIVER_CAPABILITIES=all
    runtime: nvidia
EOL
        fi
        cat >> "$compose_file" <<EOL
    volumes:
      - $media_path:/media
      - ./config:/config
    restart: unless-stopped
EOL
    fi

    if [[ "$service_name" == "filebrowser" ]]; then
        sed -i "/environment:/a\      - ADMIN_USER=$filebrowser_user\n      - ADMIN_PASSWORD=$filebrowser_password" "$compose_file"
    fi

    if [[ "$service_name" == "sonarr" || "$service_name" == "radarr" || "$service_name" == "qbittorrent" ]]; then
        if ! grep -q "$media_path:/media" "$compose_file"; then
            sed -i "/volumes:/a\      - $media_path:/media" "$compose_file"
        fi
    fi

    echo "✅ Updated: $compose_file"
done

echo "🚀 All docker-compose.yml files have been updated!"
