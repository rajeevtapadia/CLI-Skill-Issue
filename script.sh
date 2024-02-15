#!/bin/bash

while getopts ":p:" opt; do
  case $opt in
    p)
      prompt_text="$OPTARG"
      prompt_text="${prompt_text//\"/\\\"}"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Check if prompt_text is set
if [[ -z "$prompt_text" ]]; then
  echo "Error: Please provide a prompt text with the -p flag."
  exit 1
fi

# Construct and send curl request
api_key=""
# Check if api_key is empty
if [[ -z "$api_key" ]]; then
  echo "Error: Get your api key from https://makersuite.google.com and enter that in the script"
  exit 1
fi
api_url="https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$api_key"

echo "Suggesting..."

api_request_json='{
  "contents": [
    {
      "parts": [
        {
          "text": "give me the bash command for perfoming the following task: '$prompt_text' just give the command no explaination or nothing else"
        }
      ]
    }
  ]
}'

response=$(curl -s -X POST -H "Content-Type: application/json" -d "$api_request_json" "$api_url")

# Extract generated command using grep and awk
generated_command=$(echo "$response" | grep -o '"text": "[^"]*' | awk -F'"' '{print $4}')

echo "Suggested command: $generated_command"

# Blacklist of dangerous commands
blacklist=("rm -rf /" "halt" "shutdown -h now" "poweroff" "reboot")

# Check if the generated command is in the blacklist
for blacklisted_cmd in "${blacklist[@]}"; do
  if [[ "$generated_command" == *"$blacklisted_cmd"* ]]; then
    echo "Error: The generated command is blacklisted and will not be executed."
    exit 1
  fi
done

# Prompt user to execute the generated command
read -p "Do you want to execute the suggested command? (y/n): " perm
if [[ $perm == "y" || $perm == "Y" ]]; then
  echo "Executing command..."
  eval "$generated_command"
elif [[ $perm == "n" || $perm == "N" ]]; then
  echo "Command execution skipped."
else
  echo "Invalid input. Command execution skipped."
fi
