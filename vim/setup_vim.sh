#!/bin/sh
# Install vimrc for Vim/Neovim in current user's home directory

set -eu

Error() {
    echo "ERROR" "$@" 1>&2
    exit 1
}

Mydir="$(dirname -- "$0")"
[ -d "${Mydir}" ] || Error "Unable to find directory"

echo "Running for user ${USER}"
id

# Install Vim config
echo "Symlinking .vimrc"
DOTFILES_VIMRC="${Mydir}/.vimrc"
HOME_VIMRC="${HOME}/.vimrc"
[ -L "${HOME_VIMRC}" ] \
    || ln -s "${DOTFILES_VIMRC}" "${HOME_VIMRC}"

# Install Neovim config
echo "Symlinking neovim config"
HOME_NVIMRC="${HOME}/.config/nvim/init.vim"
NVIM_HOME="$(dirname -- ${HOME_NVIMRC})"
mkdir -p "${NVIM_HOME}"
[ -L "${HOME_NVIMRC}" ] \
    || ln -s "${HOME_VIMRC}" "${HOME_NVIMRC}"

# Install Plug for vim and neovim
echo "Installing Plug"
PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
VIM_PLUG_PATH="${HOME}/.vim/autoload/plug.vim"
NVIM_PLUG_PATH="${HOME}/.local/share/nvim/site/autoload/plug.vim"
mkdir -p "$(dirname -- "${VIM_PLUG_PATH}")"
mkdir -p "$(dirname -- "${NVIM_PLUG_PATH}")"
[ -e "${VIM_PLUG_PATH}" ] \
    || curl -fLo "${VIM_PLUG_PATH}" "${PLUG_URL}"
[ -e "${NVIM_PLUG_PATH}" ] \
    || cp "${VIM_PLUG_PATH}" "${NVIM_PLUG_PATH}"

echo "Done!"
