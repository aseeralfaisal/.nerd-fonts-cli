RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' 

echo "󰛖 Available from nerdfonts.com: \n"
entries=$(curl -s https://www.nerdfonts.com/font-downloads | \
grep -o 'https://github.com/ryanoasis/nerd-fonts/releases/download/[^"]*' | \
uniq | sort | \
awk -F '/releases/download/|/' '{title=$NF; sub(/\.zip$/, "", title); print NR " " title, "link: " $0}')
echo "$entries"

echo "\n󰛖 ${YELLOW}Type ID to install fonts:${NC}"
read user_id

output=$(echo "$entries" | awk -v id="$user_id" -F ' ' '$1 == id {print $4}')
wget -P ~/.fonts "$output"
file=$(basename "$output")
unzip -d ~/.fonts ~/.fonts/"$file"
rm -rf ~/.fonts/"$file"
fc-cache -r

echo "${YELLOW} 󰛖 Installed$filename font "
