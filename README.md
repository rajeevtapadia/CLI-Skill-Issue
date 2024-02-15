# CLI Skill Issue

This bash script uses Google Gemini to generate bash commands based on user prompts. It also includes safety measures to prevent the execution of potentially dangerous commands.

## Prerequisites

- Bash
- Gemini API key

## Usage

1. Clone or download the script file (`script.sh`).
2. Ensure that the script file has execute permission: `chmod +x script.sh`.
3. Run the script with the `-p` flag followed by the prompt text. For example:
   ```bash
   ./script.sh -p "create a backup of files in current directory"
   ```
4. Follow the prompts to generate and optionally execute the bash command.


## API Key

To use the Google Gemini, you need to obtain an API key from the [Google AI Studio](https://aistudio.google.com) and replace the placeholder `api_key="YOUR_API_KEY"` in the script with your actual API key.
