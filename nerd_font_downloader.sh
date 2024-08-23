RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo "󰛖 Available from nerdfonts.com:"

entries=$(curl -s https://www.nerdfonts.com/font-downloads | \
grep -o 'https://github.com/ryanoasis/nerd-fonts/releases/download/[^"]*' | \
uniq | sort | \
awk -F '/releases/download/|/' '{title=$NF; sub(/\.zip$/, "", title); print NR " " title, "link: " $0}')

echo "$entries"

echo "\n󰛖 ${YELLOW}Type ID to install fonts:${NC}"
read user_id

download_link=$(echo "$entries" | awk -v id="$user_id" -F ' ' '$1 == id {print $4}')

if [ -z "$download_link" ]; then
  echo "${RED}Invalid ID. Please try again.${NC}"
  exit 1
fi

echo "Downloading font..."
wget -P ~/.fonts "$download_link"

font_file=$(basename "$download_link")
echo "Unzipping font..."
unzip -d ~/.fonts ~/.fonts/"$font_file"

rm -rf ~/.fonts/"$font_file"

fc-cache -r

echo "${YELLOW}󰛖 Font installed successfully!${NC}"
