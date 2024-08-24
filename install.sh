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
echo

download_link=$(echo "$entries" | awk -v id="$user_id" -F ' ' '$1 == id {print $4}')
font_dir="$HOME/.fonts"

if [ -z "$download_link" ]; then
  echo "${RED}Invalid ID${NC}"
  exit 1
fi

echo " Downloading font...\n"
font_zip=$(basename "$download_link")
wget -q --show-progress -O "$font_dir"/"$font_zip" "$download_link"

echo " Extracting font...\n"
cd "$font_dir"
if unzip -o -qq "$font_zip" -d "$font_dir"; then
    fc-cache -f -r
else
    echo "Error occurred"
fi

add_alias='
nerd_fonts_cli() {
  cd ~/.nerd-fonts-cli/ || return
  chmod +x .install.sh
  ./install.sh
}
alias nerd-fonts="nerd_fonts_cli"
'
echo "$add_alias" >> ~/.zshrc

echo "󰁨 Finishing up...\n"
rm -f README.md LICENSE.txt OFL.txt
rm -f "$font_zip"

echo "${YELLOW}󰛖 Font installed successfully!${GREEN} 󰁨"
