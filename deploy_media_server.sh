!/bin/bash

# Directories containing docker-compose.yml
DIRECTORIES=(
    "/opt/media_server/plex"
    "/opt/media_server/qbittorrent"
    "/opt/media_server/radarr"
    "/opt/media_server/sonarr"
    "/opt/media_server/overseer"
    "/opt/media_server/filebrowser"
)

# Loop through each directory
for DIR in "${DIRECTORIES[@]}"; do
    echo "Processing directory: $DIR"
    if [ -f "$DIR/docker-compose.yml" ]; then
        cd "$DIR" || { echo "Failed to cd into $DIR"; exit 1; }
        echo "Pulling the latest images in $DIR..."
        docker compose pull
        echo "Updating services in $DIR..."
        docker compose up -d
    else
        echo "docker-compose.yml not found in $DIR"
    fi
done

# Prune old images
echo "Pruning old Docker images..."
docker image prune -af

echo "Docker images update and pruning complete."
