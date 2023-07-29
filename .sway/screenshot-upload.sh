#!/bin/bash
FILE="/tmp/$(openssl rand -base64 12).png"
grim -g "$(slurp)" -t png - | tee "$FILE" > /dev/null
FILE_ID=$(curl -X POST https://file.peek1e.eu/upload --form 'file=@'"$FILE" 2>/dev/null | jq -r '.fileID')
echo "https://file.peek1e.eu/pv/$FILE_ID" | wl-copy
