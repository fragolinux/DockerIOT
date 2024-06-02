#!/usr/bin/env bash

# Define color escape codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Define the root folder containing your subfolders with docker-compose.yml files
ROOT_FOLDER="."
BACKUP_ROOT="./backup"

# Create the backup root directory if it doesn't exist
mkdir -p "$BACKUP_ROOT"

# Get the current day of the week (1 for Monday, 7 for Sunday)
DAY_OF_WEEK=$(date +%u)
# Get the current date and time for the backup file naming
TIMESTAMP=$(date +%F-%H-%M)

# Function to backup a folder and handle Docker containers
backup_folder() {
  local dir="$1"
  local dirname=$(basename "$dir")
  local was_running=false
  local container_status="stopped_color"

  if [ -f "$dir/docker-compose.yml" ]; then
    # Check if any container is running in this folder
    if docker compose -f "$dir/docker-compose.yml" ps | grep -q 'Up'; then
      was_running=true
      container_status="${GREEN}running${NC}"
      echo -e "Stopping containers in ${YELLOW}$dir${NC}"
      docker compose -f "$dir/docker-compose.yml" down
    else
      container_status="${RED}stopped${NC}"
    fi

    echo -e "Performing backup of $container_status container: ${YELLOW}$dirname${NC}"

    # Create the backup directory structure
    backup_dir="$BACKUP_ROOT/$DAY_OF_WEEK-$(date +%A)/$dirname"
    mkdir -p "$backup_dir"
    backup_file="$backup_dir/$TIMESTAMP.tgz"

    # Create the tar.gz backup
    echo "Backing up $dir to $backup_file"
    tar --create --gzip --preserve-permissions --file="$backup_file" -C "$ROOT_FOLDER" "$dirname"

    # Restart the containers if they were running before
    if [ "$was_running" = true ]; then
      echo -e "Starting containers in ${YELLOW}$dir${NC}"
      docker compose -f "$dir/docker-compose.yml" up -d
    fi

    # Print an empty line before the footer line
    echo ""

    # Print the footer line
    echo "########################################"
  fi
}

# Main script execution
if [ $# -eq 0 ]; then
  for dir in "$ROOT_FOLDER"/*/; do
    if [ -d "$dir" ]; then
      backup_folder "$dir"
    fi
  done
else
  backup_folder "$1"
fi
