# 🍚 Dan's Rice & Dotfiles

Minha configuração pessoal de ambiente tiling baseada em Wayland, focada em performance, minimalismo e produtividade.

---

## 🛠️ O que está incluído?

* **Wayland Compositor:** [River](https://github.com/riverwm/river)
* **Gerenciador de Janelas / Atalhos:** Kwm / Wayland utilities
* **Terminal:** [Alacritty](https://github.com/alacritty/alacritty)
* **Editor de Texto:** [NvChad](https://nvchad.com/) (Neovim)
* **Gerenciador de Arquivos:** PCManFM (com suporte a ícones/miniaturas)
* **Barra / Status:** Waybar
* **Launcher:** Fuzzel
* **Gerenciador de Pacotes AUR:** [Paru](https://github.com/Morganamilo/paru)
* **Aplicativos e Suporte:** Flatpak + Flathub configurados

---

## 📸 Utilitários e Recursos do Sistema

O script de instalação também prepara o terreno com ferramentas essenciais para o dia a dia no Wayland:

* **Print da Tela:** `grim` + `slurp` + `swappy` (tire prints da tela inteira ou selecione uma área para editar na hora).
* **Filtro de Luz Noturna:** `wlsunset` (protege os olhos à noite mudando a temperatura da cor da tela).
* **Controle de Brilho:** `brightnessctl` (ajuste fácil do brilho via atalhos).
* **Área de Transferência:** `wl-clipboard` (copiar e colar perfeitamente no Wayland).

---

## 📦 Dependências e Instalação

Se você estiver reinstalando o sistema (ex: Arch Linux), o script automatizado (`install.sh`) cuida de tudo para você: pacotes oficiais, Paru, Flatpak, repositórios e links simbólicos das configurações.

### Instalação Automática

Clone o repositório e execute o script:

```bash
git clone [https://github.com/danmrcosta/mydotfiles.git](https://github.com/danmrcosta/mydotfiles.git) ~/rice
cd ~/rice
chmod +x install.sh
./install.sh
