#!/usr/bin/env bash
set -euo pipefail

if ! command -v dialog $> /dev/null; then
  echo \"dialog\" executable missing, please install it... exiting
  exit 1
fi

if ! command -v jq $> /dev/null; then
  echo \"jq\" executable missing, please install it... exiting
  exit 1
fi

if ! command -v docker $> /dev/null; then
  echo \"docker\" executable missing, please install it... exiting
  exit 1
fi

set +e
docker compose &>/dev/null
if [ $? -ne 0 ]; then
  echo Docker \"compose\" plugin missing, please install it... exiting
  exit 1
fi
set -e

export NCURSES_NO_UTF8_ACS=1

get_service_ports() {
  local folder="$1"
  ports=$(docker compose -f "$folder"/docker-compose.yml ps --format '{{if index .Publishers 0}}{{range .Publishers}}{{if ne .PublishedPort 0}}{{$.Service}} {{.PublishedPort}} |{{end}}{{end}}{{end}}' | awk NF | tr '\n' ' ')
  if [[ "$ports" == "" ]]; then
    if [[ $(docker compose -f "$folder"/docker-compose.yml ps --format '{{.State}}') == "running" ]]; then
      echo "Running (no ports exposed)"
    else
      echo "Not Running"
    fi
  else
    echo "[ ${ports::-3} ]"
  fi
}

get_service_status() {
  local folder="$1"
  docker compose -f "$folder"/docker-compose.yml ps --format json
}

# Function to display service menu and execute action
perform_service_action() {
  local folder="$1"
  service_status=$(get_service_status "$folder")
  
  # Define service action options as an array
  service_actions=()
  tot_actions=0
  service_actions+=("backup" "Backup $folder services") && ((tot_actions+=1))
  [ "$service_status" = "" ] && service_actions+=("start" "Start $folder services") && ((tot_actions+=1))
  [ "$service_status" != "" ] && service_actions+=("stop" "Stop $folder services") && ((tot_actions+=1))
  [ "$service_status" != "" ] && service_actions+=("restart" "Restart $folder services") && ((tot_actions+=1))
  [ "$service_status" != "" ] && service_actions+=("logs" "Show $folder services logs") && ((tot_actions+=1))
  service_actions+=("update" "Update $folder services image") && ((tot_actions+=1))
  # for now commented out shell access, it needs to select the specific container in the service
  # [ "$service_status" != "" ] && service_actions+=("sh" "Run SH shell in $folder services") && ((tot_actions+=1))
  # [ "$service_status" != "" ] && service_actions+=("bash" "Run BASH shell $folder services") && ((tot_actions+=1))

  # Get user selection from menu
  a1=$((tot_actions+7))
  a2=$((tot_actions+2))
  selected_action=$(dialog --title "Select Action" --menu "What do do on $folder service:" $a1 60 $a2 "${service_actions[@]}" 3>&1 1>&2 2>&3)
  echo "$selected_action"

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
    if  [[ "$selected_action" == "backup" ]]; then
      echo "Executing: backup.sh $folder"
      bash backup.sh "$folder"
    elif [[ "$selected_action" == "start" ]]; then
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
    # these 2 could not work if more than 1 container in docker compose, it needs to select the specific container in the service # TODO
    elif [[ "$selected_action" == "sh" ]]; then
      echo "Executing: $DC exec $folder /bin/sh"
      $DC exec "$folder" /bin/sh
    elif [[ "$selected_action" == "bash" ]]; then
      echo "Executing: $DC exec $folder /bin/bash"
      $DC exec "$folder" /bin/bash
    fi
  fi
}

# Get all docker-compose.yml files in the current directory and one subdirectory
# shellcheck disable=SC2207
folders=( $(find . -maxdepth 2 -name 'docker-compose.yml' -print | sed 's/\/docker-compose.yml//' | sort ) )

# Check if any files found
if [[ ${#folders[@]} -eq 0 ]]; then
  dialog --msgbox "Error: No docker-compose.yml files found in current directory or subdirectories." 10 30
  exit 1
fi

# Loop through folders and build menu options with stripped folder names
options=()
tot_folders=0
max_length=0
for folder in "${folders[@]}"; do
  # Remove leading ./ from folder name using parameter expansion
  ((tot_folders+=1))
  folder_name="${folder##*/}"
  service_ports=$(get_service_ports "$folder")
  total_length=$(( ${#folder_name} + ${#service_ports} ))
  [[ "$total_length" -gt "$max_length" ]] && max_length="$total_length"
  options+=( "$folder_name" "$service_ports" )
done

f1=$((tot_folders+7))
f2=$((tot_folders+2))
lenght=$((max_length+22))
# Display menu with folder name (without ./) and service name (without trailing colon)
choice=$(dialog --title "Select Service to access Actions" --menu "Services ports shown, if service running:" $f1 $lenght $f2 "${options[@]}" 3>&1 1>&2 2>&3)

# Exit status check (user cancellation or error)
exit_status=$?
if [[ $exit_status -eq 1 ]]; then
  echo "Selection cancelled."
elif [[ $exit_status -eq 255 ]]; then
  echo "An error occurred."
else
  # Extract selected folder and service name (if selection happened)
  selected_folder="${choice%% *}"

  # Call function to display service action menu
  perform_service_action "$selected_folder"
fi
