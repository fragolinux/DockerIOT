#!/usr/bin/env bash
set -euo pipefail

if ! command -v dialog $> /dev/null; then
  echo \"dialog\" executable missing, please install it... exiting
  exit 1
fi

set +e
docker compose &>/dev/null # sending output to /dev/null because we don't want it printed
if [ $? -ne 0 ]; then
  echo Docker \"compose\" plugin missing, please install it... exiting
  exit 1
fi
set -e

export NCURSES_NO_UTF8_ACS=1

# Function to get service name from a folder
get_service_name() {
  local folder="$1"
  # Extract service name from docker-compose.yml (modify if different filename)
  awk '/^services:$/ { getline; sub(/:$/, "", $1); print $1 }' "$folder/docker-compose.yml"
}

get_service_status() {
  local folder="$1"
  local service_name="$2"
  [[ $(docker compose -f $folder/docker-compose.yml ps --format "{{.State}}" $service_name) = "running" ]] && echo R || echo " "
}

# Function to display service menu and execute action
perform_service_action() {
  local folder="$1"
  local service_name="$2"
  service_status=$(docker compose -f $folder/docker-compose.yml ps --format "{{.State}}" $service_name)
  # Define service action options as an array
  service_actions=()
  [ "$service_status" != "running" ] && service_actions+=("start" "Start $service_name container")
  [ "$service_status" = "running" ] && service_actions+=("stop" "Stop $service_name container")
  [ "$service_status" = "running" ] && service_actions+=("restart" "Restart $service_name container")
  [ "$service_status" = "running" ] && service_actions+=("logs" "Show $service_name container logs")
  service_actions+=("update" "Update $service_name container image")
  [ "$service_status" = "running" ] && service_actions+=("sh" "Run SH shell in $service_name container")
  [ "$service_status" = "running" ] && service_actions+=("bash" "Run BASH shell $service_name container")

  # Get user selection from menu
  selected_action=$(dialog --title "Select Action" --menu "What do do on $service_name container:" 15 60 10 "${service_actions[@]}" 3>&1 1>&2 2>&3)
  echo $selected_action

  DC="docker compose -f $folder/docker-compose.yml"
  # Check exit status and selected action
  exit_status=$?
  if [[ $exit_status -eq 1 ]]; then
    echo "Action cancelled."
  elif [[ $exit_status -eq 255 ]]; then
    echo "An error occurred."
  else
    # Simulate command execution (replace with actual execution for production use)
    # You can use libraries like subprocess to execute the command in production
    if [[ "$selected_action" == "start" ]]; then
      echo "Executing: $DC up -d"
      $DC up -d
    elif [[ "$selected_action" == "stop" ]]; then
      echo "Executing: $DC down"
      $DC down
    elif [[ "$selected_action" == "restart" ]]; then
      echo "Executing: $DC down; $DC up -d"
      $DC down; $DC up -d
    elif [[ "$selected_action" == "logs" ]]; then
      echo "Executing: $DC logs -f"
      $DC logs -f
    elif [[ "$selected_action" == "update" ]]; then
      echo "Executing: $DC down; $DC pull; $DC up -d"
      $DC down; $DC pull; $DC up -d
    elif [[ "$selected_action" == "sh" ]]; then
      echo "Executing: $DC exec $service_name /bin/sh"
      $DC exec $service_name /bin/sh
    elif [[ "$selected_action" == "bash" ]]; then
      echo "Executing: $DC exec $service_name /bin/bash"
      $DC exec $service_name /bin/bash
    fi
  fi
}

# Get all docker-compose.yml files in the current directory and one subdirectory
folders=( $(find . -maxdepth 2 -name 'docker-compose.yml' -print | sed 's/\/docker-compose.yml//' ) )

# Check if any files found
if [[ ${#folders[@]} -eq 0 ]]; then
  dialog --msgbox "Error: No docker-compose.yml files found in current directory or subdirectories." 10 30
  exit 1
fi

# Loop through folders and build menu options with stripped folder names
options=()
for folder in "${folders[@]}"; do
  # Remove leading ./ from folder name using parameter expansion
  folder_name="${folder##*/}"
  service_name=$(get_service_name "$folder")
  service_status=$(get_service_status "$folder" "$service_name")
  options+=( "$folder_name" "(service: $service_status $service_name)" )
done

# Display menu with folder name (without ./) and service name (without trailing colon)
choice=$(dialog --title "Select Service to access Actions" --menu "R states container is RUNNING:" 15 60 10 "${options[@]}" 3>&1 1>&2 2>&3)

# Exit status check (user cancellation or error)
exit_status=$?
if [[ $exit_status -eq 1 ]]; then
  echo "Selection cancelled."
elif [[ $exit_status -eq 255 ]]; then
  echo "An error occurred."
else
  # Extract selected folder and service name (if selection happened)
  selected_folder="${choice%% *}"
  selected_service=$(get_service_name "$selected_folder")

  # Call function to display service action menu
  perform_service_action "$selected_folder" "$selected_service"
fi
