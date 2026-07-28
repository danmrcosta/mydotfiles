#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Iniciando a instalação do Rice do Dan ===${NC}"

# 1. Atualizar o sistema e instalar pacotes base do Arch (incluindo Flatpak)
echo -e "${GREEN}[1/5] Instalando pacotes e dependências oficiais (Pacman)...${NC}"
sudo pacman -Syu --needed \
    git \
    base-devel \
    alacritty \
    neovim \
    pcmanfm \
    gvfs \
    file-roller \
    otf-font-awesome \
    ttf-jetbrains-mono-nerd \
    fuzzel \
    waybar \
    mako \
    polkit-gnome \
    grim \
    slurp \
    swappy \
    wlsunset \
    brightnessctl \
    wl-clipboard \
    flatpak

# 2. Configurar o Flathub para o Flatpak
echo -e "${GREEN}[2/5] Adicionando o repositório Flathub ao Flatpak...${NC}"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# 3. Instalar o Paru (AUR Helper) se não existir
if ! command -v paru &> /dev/null; then
    echo -e "${GREEN}[3/5] Instalando o Paru (AUR helper)...${NC}"
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru
    makepkg -si --noconfirm
    cd ~/rice
else
    echo -e "${GREEN}[3/5] Paru já está instalado.${NC}"
fi

# 4. Instalar pacotes do AUR (como o riverwm)
echo -e "${GREEN}[4/5] Instalando pacotes do AUR (River compositor, etc)...${NC}"
paru -S --needed --noconfirm river-git

# 5. Configurando os Symlinks das Dotfiles
echo -e "${GREEN}[5/5] Aplicando dotfiles (symlinks)...${NC}"

# Criar pastas de config se não existirem
mkdir -p ~/.config

# Alacritty
ln -sfn ~/rice/alacritty ~/.config/alacritty

# NvChad (Neovim)
ln -sfn ~/rice/nvim ~/.config/nvim

# River
ln -sfn ~/rice/river ~/.config/river

# PCManFM
mkdir -p ~/.config/pcmanfm/default
ln -sfn ~/rice/pcmanfm ~/.config/pcmanfm/default/settings.conf 2>/dev/null || true

echo -e "${BLUE}=== Instalação concluída com sucesso! Reinicie a sessão para carregar o River. ===${NC}"
