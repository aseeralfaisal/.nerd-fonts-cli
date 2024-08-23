RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo "${GREEN}󰛖 Available from nerdfonts.com:${NC}"

entries=$(curl -s https://www.nerdfonts.com/font-downloads | \
grep -o 'https://github.com/ryanoasis/nerd-fonts/releases/download/[^"]*' | \
uniq | sort | \
awk -F '/releases/download/|/' '{title=$NF; sub(/\.zip$/, "", title); print NR " " title, "link: " $0}')

echo "$entries"

echo "\n󰛖 ${YELLOW}Type ID to install fonts:${NC}"
read user_id

download_link=$(echo "$entries" | awk -v id="$user_id" -F ' ' '$1 == id {print $4}')
temp_dir=$(mktemp -d)

if [ -z "$download_link" ]; then
  echo "${RED}Invalid ID${NC}"
  exit 1
fi

echo " Downloading font...\n"
wget -P ~/.fonts "$download_link"

font_file=$(basename "$download_link")
echo " Unzipping font...\n"
unzip -o -d "$temp_dir" ~/.fonts/"$font_file"

cd "$temp_dir"
find . -type f \( -name 'LICENSE.txt' -o -name 'README.md' \) -delete

rm -rf ~/.fonts/"$font_file"
rm -rf "$temp_dir"

fc-cache -f -v

echo "${YELLOW}󰛖 Font installed successfully!${NC}"
