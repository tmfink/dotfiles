#!/bin/sh
# Install vimrc for Vim/Neovim in current user's home directory

set -eu

Error() {
    echo "ERROR" "$@" 1>&2
    echo "exiting..." 1>&2
    exit 1
}

Mydir="$(dirname -- "$0")"
[ -d "${Mydir}" ] || Error "Unable to find directory"

echo "Running for user ${USER}"
id

abs_path() {
    dir_abs="$(cd "$(dirname -- "$1")" && pwd)"
    echo "${dir_abs}/$(basename -- "$1")"
}

rel_path() {
    python3 -c '
import os.path
import sys

print(os.path.relpath(sys.argv[1], sys.argv[2]))
' "$@"
}

link_vimrc() {
    src="$(abs_path "$1")"; shift
    dst="$(abs_path "$1")"; shift

    dst_dir="$(dirname -- "${dst}")"
    dst_base="$(basename -- "${dst}")"

    rel_dst="$(rel_path "${src}" "${dst_dir}")" \
        || Error "Failed to compute relative path"

    if [ -L "${dst}" ]; then
        echo "Symlink ${dst} already exists, nothing to do"
    elif [ -e "${dst}" ]; then
        Error "Non-symlink file ${dst} already exists; manually resolve/backup"
    else
        echo "Creating symlink ${src} -> ${dst}"
        (cd "${dst_dir}" && ln -s "${rel_dst}" "${dst_base}" ) \
            || Error "Failed to create symlink"
    fi
}

# Install Vim config
echo "Symlinking .vimrc"
DOTFILES_VIMRC="${Mydir}/.vimrc"
HOME_VIMRC="${HOME}/.vimrc"
link_vimrc "${DOTFILES_VIMRC}" "${HOME_VIMRC}"

# Install Neovim config
echo "Symlinking neovim config"
DOTFILES_INIT_LUA="${Mydir}/init.lua"
HOME_NVIMRC_OLD="${HOME}/.config/nvim/init.vim"
HOME_NVIMRC="${HOME}/.config/nvim/init.lua"
NVIM_HOME="$(dirname -- "${HOME_NVIMRC}")"
mkdir -p "${NVIM_HOME}"
if [ -e "${HOME_NVIMRC_OLD}" ] ; then
    if [ -s "${HOME_NVIMRC_OLD}" ]; then
        echo "delete old init.vim symlink: ${HOME_NVIMRC_OLD}"
        rm "${HOME_NVIMRC_OLD}"
    else
        Error "Old init.vim file exists; handle manually: ${HOME_NVIMRC_OLD}"
    fi
fi
link_vimrc "${DOTFILES_INIT_LUA}" "${HOME_NVIMRC}"

# Install Plug for vim (neovim "init.lua" automatically installs plug)
echo "Installing Plug"
PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
VIM_PLUG_PATH="${HOME}/.vim/autoload/plug.vim"
mkdir -p "$(dirname -- "${VIM_PLUG_PATH}")"
[ -e "${VIM_PLUG_PATH}" ] \
    || curl -fLo "${VIM_PLUG_PATH}" "${PLUG_URL}"

echo "Done!"
