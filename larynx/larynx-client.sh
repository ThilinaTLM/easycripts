#!/bin/bash

if [[ "$1" == "--" ]]; then
  text=$(cat)
else
  text="$1"
fi

text="$1"
voice="$2"

if [ -z "$text" ]; then
    echo "Usage: $0 <text> [voice]"
    exit 1
fi

if [ -z "$voice" ]; then
    voice="en-us/mary_ann-glow_tts"
fi

curl -X POST "http://localhost:5002/api/tts?voice=$voice" \
    -H 'Content-Type: text/plain' \
    -d "$text" \
    --output -

