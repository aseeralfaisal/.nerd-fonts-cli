config='
nerd_fonts_cli() {
  cd ~/.nerd-fonts-cli/ || return
  chmod +x .install.sh
  ./install.sh
}
alias nerd-fonts="nerd_fonts_cli"
'
echo "$config" >> ~/.zshrc

