#!/bin/bash

# Variables
PBF_URL="https://download.geofabrik.de/australia-oceania/australia-latest.osm.pbf"
PBF_FILE="australia-latest.osm.pbf"
DOCKER_VOLUME="osm-data"
CONTAINER_IMAGE="overv/openstreetmap-tile-server"
CONTAINER_NAME="osm_tile_server"

# Check if the OSM data file already exists
if [ -f "$PBF_FILE" ]; then
    echo "OSM data file already exists, skipping download."
else
    echo "Downloading OSM data..."
    wget $PBF_URL -O $PBF_FILE
    if [ $? -ne 0 ]; then
        echo "Download failed, exiting."
        exit 1
    fi
fi

# Check if the container already exists and remove it
if [ "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]; then
    echo "Container $CONTAINER_NAME already exists. Removing it..."
    docker rm -f $CONTAINER_NAME
    if [ $? -ne 0 ]; then
        echo "Failed to remove existing container, exiting."
        exit 1
    fi
fi

# Check if the Docker volume already exists
if docker volume inspect $DOCKER_VOLUME >/dev/null 2>&1; then
    echo "Docker volume $DOCKER_VOLUME already exists."

    # Remove the existing Docker volume
    echo "Removing the existing Docker volume..."
    docker volume rm $DOCKER_VOLUME
    if [ $? -ne 0 ]; then
        echo "Failed to remove existing Docker volume, exiting."
        exit 1
    fi
fi

# Remove any existing images related to the tile server
IMAGE_IDS=$(docker images -q $CONTAINER_IMAGE)
if [ -n "$IMAGE_IDS" ]; then
    echo "Removing existing Docker images..."
    docker rmi -f $IMAGE_IDS
fi

# Create a new Docker volume for the data
echo "Creating Docker volume..."
docker volume create $DOCKER_VOLUME

# Import the data into the tile server
echo "Importing data into the tile server..."
docker run --name $CONTAINER_NAME -v $(pwd)/$PBF_FILE:/data/region.osm.pbf -v $DOCKER_VOLUME:/data/database/ $CONTAINER_IMAGE import

# Check if import was successful
if [ $? -eq 0 ]; then
    echo "Import complete"
else
    echo "Import failed. Cleaning up..."
    docker rm -f $CONTAINER_NAME
    docker volume rm $DOCKER_VOLUME
    exit 1
fi

echo "Setup complete. You can now run the tile server using Docker Compose."
