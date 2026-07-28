#!/usr/bin/env bash
#
# statusbar.sh — feeder da bar nativa do kwm (estilo dwm), via fifo.
#
# Substitui o quickshell. Não existe systray de verdade na bar do kwm
# (sem protocolo StatusNotifierItem), então "ícones" de wifi e de apps
# em 2º plano são glifos de uma Nerd Font escritos como texto no fifo
# de status. Por isso o .font do .bar no config.zon precisa ser uma
# Nerd Font instalada (ex.: JetBrainsMono Nerd Font).
#
# Instalação:
#   mkdir -p ~/.config/kwm/scripts
#   cp statusbar.sh ~/.config/kwm/scripts/statusbar.sh
#   chmod +x ~/.config/kwm/scripts/statusbar.sh
#
# O caminho do fifo abaixo TEM que ser exatamente igual ao valor de
# .bar.status no config.zon.

FIFO="$HOME/.cache/kwm/statusbar.fifo"
mkdir -p "$(dirname "$FIFO")"
[ -p "$FIFO" ] || mkfifo "$FIFO"

# ---------------------------------------------------------------------------
# Wifi — glifo + SSID via nmcli (troque se não usar NetworkManager).
# nf-fa-wifi = \uf1eb   |  "desconectado" quando não há conexão wifi ativa.
# ---------------------------------------------------------------------------
get_wifi() {
    local con
    con=$(nmcli -t -f TYPE,STATE,CONNECTION device status 2>/dev/null \
        | awk -F: '$1=="wifi" && $2=="connected"{print $3; exit}')
    if [ -n "$con" ]; then
        printf ' %s' "$con"
    else
        printf ' desconectado'
    fi
}

# ---------------------------------------------------------------------------
# Apps em 2º plano — um glifo por app rodando, tipo mini-tray textual.
# Confira o nome real do processo com `ps -e` e ajuste os pgrep -x se
# necessário (ex.: Spotify via flatpak pode ter outro nome de binário,
# OBS pode chamar "obs" ou "obs-studio").
# ---------------------------------------------------------------------------
get_apps() {
    local out=""
    pgrep -x spotify        >/dev/null && out="$out "  # nf-fa-spotify
    pgrep -x obs             >/dev/null && out="$out "  # nf-fa-video-camera
    pgrep -x obs-studio       >/dev/null && out="$out "
    pgrep -x Discord         >/dev/null && out="$out "  # nf-fa-discord
    pgrep -x discord          >/dev/null && out="$out "
    pgrep -x telegram-desktop >/dev/null && out="$out "  # nf-fa-telegram
    pgrep -x steam            >/dev/null && out="$out "  # nf-fa-steam
    printf '%s' "$out"
}

# ---------------------------------------------------------------------------
# Volume — glifo mudo/normal via wpctl (mesmo backend já usado nos binds
# de mídia do seu config.zon).
# ---------------------------------------------------------------------------
get_volume() {
    local info vol muted
    info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
    muted=$(printf '%s' "$info" | grep -c MUTED)
    vol=$(printf '%s' "$info" | awk '{printf "%d", $2*100}')
    if [ "$muted" -gt 0 ] || [ -z "$vol" ]; then
        printf ' mudo'
    else
        printf ' %s%%' "$vol"
    fi
}

# ---------------------------------------------------------------------------
# Loop principal — o relógio atualiza todo segundo; wifi/apps/volume só
# são reconsultados a cada 10s pra não ficar chamando nmcli/pgrep/wpctl
# toda hora à toa.
# ---------------------------------------------------------------------------
i=0
WIFI=""
APPS=""
VOL=""
while true; do
    if (( i % 10 == 0 )); then
        WIFI="$(get_wifi)"
        APPS="$(get_apps)"
        VOL="$(get_volume)"
    fi

    printf ' %s   %s   %s   %s \n' \
        "$WIFI" "$APPS" "$VOL" "$(date +'%b %d %Y | %H:%M')" > "$FIFO"

    sleep 1
    i=$((i + 1))
done
