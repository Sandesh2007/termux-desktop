#!/data/data/com.termux/files/usr/bin/bash

## Author  : Aditya Shakya (adi1090x)
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

## Modified by Sandesh2007

## Termux Desktop : Setup GUI in Termux 

## ANSI Colors (FG & BG)
RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"

## Reset terminal colors
reset_color() {
	printf '\033[37m'
}

## Script Termination
exit_on_signal_SIGINT() {
    { printf "${RED}\n\n%s\n\n" "[!] Program Interrupted." 2>&1; reset_color; }
    exit 0
}

exit_on_signal_SIGTERM() {
    { printf "${RED}\n\n%s\n\n" "[!] Program Terminated." 2>&1; reset_color; }
    exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

## Banner
banner() {
	clear
    cat <<- EOF
		${RED}┌──────────────────────────────────────────────────────────┐
		${RED}│${GREEN}░░░▀█▀░█▀▀░█▀▄░█▄█░█░█░█░█░░░█▀▄░█▀▀░█▀▀░█░█░▀█▀░█▀█░█▀█░░${RED}│
		${RED}│${GREEN}░░░░█░░█▀▀░█▀▄░█░█░█░█░▄▀▄░░░█░█░█▀▀░▀▀█░█▀▄░░█░░█░█░█▀▀░░${RED}│
		${RED}│${GREEN}░░░░▀░░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░░░▀▀░░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀░░░░${RED}│
		${RED}└──────────────────────────────────────────────────────────┘
		${BLUE}By : Aditya Shakya || Modified by : Sandesh2007 
	EOF
}

## Show usages
usage() {
	banner
	echo -e ${ORANGE}"\nInstall GUI (Openbox Desktop) on Termux"
	echo -e ${ORANGE}"Usages : $(basename $0) --install | --uninstall \n"
}

## Update, X11-repo, Program Installation
_pkgs=(bc bmon calc calcurse curl dbus desktop-file-utils elinks feh fontconfig-utils fsmon \
		geany git gtk2 gtk3 htop imagemagick jq leafpad man mpc mpd mutt ncmpcpp \
		ncurses-utils neofetch netsurf obconf openbox openssl-tool polybar ranger rofi \
		startup-notification termux-api thunar  x11-repo vim wget xarchiver xbitmaps xcompmgr \
		xfce4-settings xfce4-terminal xmlstarlet xorg-font-util xorg-xrdb zsh)

setup_base() {
	echo -e ${RED}"\n[*] Installing Termux Desktop..."
	echo -e ${CYAN}"\n[*] Updating Termux Base... \n"
	{ reset_color; apt autoclean; apt update -y; apt upgrade -y; }
	echo -e ${CYAN}"\n[*] Enabling Termux X11-repo... \n"
	{ reset_color; apt install -y x11-repo; }
	echo -e ${CYAN}"\n[*] Installing required programs... \n"
	for package in "${_pkgs[@]}"; do
		{ reset_color; apt install -y "$package"; }
		_ipkg=$(apt list --installed "$package" 2>/dev/null | tail -n 1)
		_checkpkg=${_ipkg%/*}
		if [[ "$_checkpkg" == "$package" ]]; then
			echo -e ${GREEN}"\n[*] Package $package installed successfully.\n"
			continue
		else
			echo -e ${MAGENTA}"\n[!] Error installing $package, Terminating...\n"
			{ reset_color; exit 1; }
		fi
	done
	reset_color
}

## Setup OMZ and Termux Configs
setup_omz() {
	# backup previous termux and omz files
	echo -e ${RED}"[*] Setting up OMZ and termux configs..."
	omz_files=(.oh-my-zsh .termux .zshrc)
	for file in "${omz_files[@]}"; do
		echo -e ${CYAN}"\n[*] Backing up $file..."
		if [[ -f "$HOME/$file" || -d "$HOME/$file" ]]; then
			{ reset_color; mv -u ${HOME}/${file}{,.old}; }
		else
			echo -e ${MAGENTA}"\n[!] $file Doesn't Exist."			
		fi
	done
	# installing omz
	echo -e ${CYAN}"\n[*] Installing Oh-my-zsh... \n"
	{ reset_color; git clone https://github.com/robbyrussell/oh-my-zsh.git --depth 1 $HOME/.oh-my-zsh; }
	cp $HOME/.oh-my-zsh/templates/zshrc.zsh-template $HOME/.zshrc
	sed -i -e 's/ZSH_THEME=.*/ZSH_THEME="aditya"/g' $HOME/.zshrc

	# ZSH theme
	cat > $HOME/.oh-my-zsh/custom/themes/aditya.zsh-theme <<- _EOF_
		# Default OMZ theme

		if [[ "\$USER" == "root" ]]; then
		  PROMPT="%(?:%{\$fg_bold[red]%}%{\$fg_bold[yellow]%}%{\$fg_bold[red]%} :%{\$fg_bold[red]%} )"
		  PROMPT+='%{\$fg[cyan]%}  %c%{\$reset_color%} \$(git_prompt_info)'
		else
		  PROMPT="%(?:%{\$fg_bold[red]%}%{\$fg_bold[green]%}%{\$fg_bold[yellow]%} :%{\$fg_bold[red]%} )"
		  PROMPT+='%{\$fg[cyan]%}  %c%{\$reset_color%} \$(git_prompt_info)'
		fi

		ZSH_THEME_GIT_PROMPT_PREFIX="%{\$fg_bold[blue]%}  git:(%{\$fg[red]%}"
		ZSH_THEME_GIT_PROMPT_SUFFIX="%{\$reset_color%} "
		ZSH_THEME_GIT_PROMPT_DIRTY="%{\$fg[blue]%}) %{\$fg[yellow]%}✗"
		ZSH_THEME_GIT_PROMPT_CLEAN="%{\$fg[blue]%})"
	_EOF_
	# Append some aliases
	cat >> $HOME/.zshrc <<- _EOF_
		#------------------------------------------
		alias l='ls -lh'
		alias ll='ls -lah'
		alias la='ls -a'
		alias ld='ls -lhd'
		alias p='pwd'

		#alias rm='rm -rf'
		alias u='cd $PREFIX'
		alias h='cd $HOME'
		alias :q='exit'
		alias grep='grep --color=auto'
		alias open='termux-open'
		alias lc='lolcat'
		alias xx='chmod +x'
		alias rel='termux-reload-settings'

		#------------------------------------------

		# SSH Server Connections

		# linux (Arch)
		#alias arch='ssh UNAME@IP -i ~/.ssh/id_rsa.DEVICE'

		# linux sftp (Arch)
		#alias archfs='sftp -i ~/.ssh/id_rsa.DEVICE UNAME@IP'
	_EOF_

	# configuring termux
	echo -e ${CYAN}"\n[*] Configuring Termux..."
	if [[ ! -d $HOME/.termux ]]; then
		mkdir -p $HOME/.termux
	fi
	cat > $HOME/.termux/termux.properties <<- _EOF_
		extra-keys = [['ESC','|','/','HOME','UP','END','PGUP','DEL'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN','BKSP']]
	_EOF_
	reset_color
}

## Configure Openbox and Xorg
config_xorg() {
	echo -e ${RED}"\n[*] Setting up and configuring Xorg..."
	echo -e ${CYAN}"\n[*] Configuring Openbox..."
	# openbox configuration
	mkdir -p $HOME/.config/openbox
	cat > $HOME/.config/openbox/autostart <<- _EOF_
		## Disable any beep
		xset -b

		## Background
		feh --bg-fill --randomize \$HOME/.wallpapers/*

		## Polybar
		polybar -r example &
		
		## Disable any beep
		xset -b
	_EOF_

	cat > $HOME/.config/openbox/menu.xml <<- _EOF_
		<?xml version="1.0" encoding="UTF-8"?>
		<!DOCTYPE openbox_menu SYSTEM "http://openbox.org/3.4/menu.dtd">
		<openbox_menu>
			<menu id="root-menu" label="Openbox 3">
				<item label="Terminal">
					<action name="Execute">
						<command>xfce4-terminal</command>
					</action>
				</item>
				<item label="Browser">
					<action name="Execute">
						<command>netsurf</command>
					</action>
				</item>
				<separator/>
				<item label="Edit config">
					<action name="Execute">
						<command>geany ~/.config/openbox/menu.xml</command>
					</action>
				</item>
				<separator/>
				<item label="Exit">
					<action name="Execute">
						<command>pkill -KILL -u $(whoami)</command>
					</action>
				</item>
			</menu>
		</openbox_menu>
	_EOF_
	
	mkdir -p $HOME/.config/polybar
	cat > $HOME/.config/polybar/config <<- _EOF_
		[colors]
		background = #2E3440
		background-alt = #353C4A
		foreground = #D8DEE9
		foreground-alt = #B9BBBF

		[bar/example]
		width = 100%
		height = 27
		padding-right = 2%
		padding-left = 2%
		background = \${colors.background}
		foreground = \${colors.foreground}
		bottom = false

		module-margin-left = 1
		module-margin-right = 2

		font-0 = "FiraCode Nerd Font:size=10;2"
		font-1 = "FontAwesome:size=12;2"
		font-2 = "NotoSans-Regular:size=10;2"

		[modules-left]
		modules-left = date

		[module/date]
		type = internal/date
		date = %Y-%m-%d %H:%M:%S
		interval = 5

		background = \${colors.background}
		foreground = \${colors.foreground}
	_EOF_

	echo -e ${CYAN}"\n[*] Configuring Xorg..."
	mkdir -p $HOME/.vnc
	cat > $HOME/.vnc/xstartup <<- _EOF_
		#!/data/data/com.termux/files/usr/bin/sh
		## Xvnc startup script

		## Set Wallpaper
		feh --bg-fill --randomize \$HOME/.wallpapers/* &

		## xset configs
		xsetroot -cursor_name left_ptr
		xset -b

		## Openbox Startup
		openbox-session &
	_EOF_
	chmod +x $HOME/.vnc/xstartup

	# Download Wallpaper
	echo -e ${CYAN}"\n[*] Downloading Wallpapers..."
	if [[ ! -d $HOME/.wallpapers ]]; then
		mkdir -p $HOME/.wallpapers
	fi
	if [[ ! -f $HOME/.wallpapers/.wallpaper1.jpg ]]; then
		{ reset_color; curl -L https://github.com/adi1090x/files/raw/master/wallpapers/blackarch1.jpg -o $HOME/.wallpapers/.wallpaper1.jpg; }
		{ reset_color; curl -L https://github.com/adi1090x/files/raw/master/wallpapers/blackarch2.jpg -o $HOME/.wallpapers/.wallpaper2.jpg; }
	else
		echo -e ${MAGENTA}"\n[!] Wallpapers Already Exists."
	fi
	reset_color
}

## Start VNC Server
start_vnc() {
	echo -e ${RED}"\n[*] Starting VNC Server..."
	vncserver -geometry 1280x720 -depth 24
	echo -e ${GREEN}"\n[+] VNC Server Started."
	reset_color
}

## Terminate VNC Server
stop_vnc() {
	echo -e ${RED}"\n[*] Stopping VNC Server..."
	vncserver -kill :1
	echo -e ${GREEN}"\n[+] VNC Server Stopped."
	reset_color
}

## Setup complete
complete() {
	banner
	echo -e ${GREEN}"[*] Setup Complete."
	echo -e ${ORANGE}"[*] For VNC Server, You can start/stop using the commands below :"
	echo -e ${BLUE}"\n\n# To Start VNC Server \n~ \$ vncserver -geometry 1280x720 -depth 24"
	echo -e ${BLUE}"\n# To Stop VNC Server \n~ \$ vncserver -kill :1\n\n"
	reset_color
	exit 0
}

## User Arguments
user_args() {
	banner
	case "$1" in
		--install)
			setup_base
			setup_omz
			config_xorg
			complete
			;;
		--uninstall)
			echo -e ${RED}"[*] Uninstalling Termux Desktop..."
			{ reset_color; apt remove --purge -y ${_pkgs[@]}; }
			echo -e ${GREEN}"[*] Termux Desktop Uninstalled."
			reset_color
			exit 0
			;;
		*)
			usage
			exit 1
			;;
	esac
}

## Main
main() {
	user_args "$@"
}

main "$@"
