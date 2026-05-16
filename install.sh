#!/bin/bash
set -e

IS_WSL=false
if grep -qi microsoft /proc/version &> /dev/null; then
	IS_WSL=true
fi

echo "Updating APT and installing base packages..."
sudo apt-get update
sudo apt-get install -y curl git zsh ca-certificates

if [ "$IS_WSL" = true ]; then
	echo "Optimizing WSL Interop..."
	if [ ! -f "/etc/wsl.conf" ] || ! grep -q "appendWindowsPath" "/etc/wsl.conf"; then
    		echo -e "[interop]\nappendWindowsPath = false" | sudo tee -a /etc/wsl.conf > /dev/null
    		echo "Added wsl.conf. (Requires 'wsl --shutdown' from Windows later to take effect)"
	fi
else
    echo "Native Linux detected. Skipping WSL-specific configurations..."
fi


if ! command -v docker &> /dev/null; then
	echo "Installing Docker Engine..."

	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc

	echo \
		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
		$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
		sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update
    	sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	sudo usermod -aG docker $(whoami)
    	echo "User added to the docker group."

	sudo systemctl enable docker.service || true
    	sudo systemctl enable containerd.service || true

	if [ -d /run/systemd/system ]; then
		sudo systemctl start docker.service
		sudo systemctl start containerd.service
	else
		echo "systemd is pending reboot. Docker will start on the next WSL boot."
	fi
else
	echo "Docker is already installed."
fi


if [ ! -d "/nix" ]; then
	echo "Installing Nix package manager..."
	sh <(curl -L https://nixos.org/nix/install) --daemon --yes
else
	echo "Nix already installed"
fi

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
	. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

echo "Installing global dependencies..."
nix-env -iA \
	nixpkgs.neovim \
	nixpkgs.eza \
	nixpkgs.fzf \
	nixpkgs.zoxide \
	nixpkgs.bat \
	nixpkgs.ripgrep \
	nixpkgs.git-delta \
	nixpkgs.direnv \
	nixpkgs.oh-my-posh \
	nixpkgs.zellij \

export PATH="$HOME/.local/bin:$PATH"

if ! command -v chezmoi &> /dev/null; then
    echo "Installing Chezmoi and fetching dotfiles..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply Catrilao
else
    echo "Chezmoi already installed, pulling latest..."
    ~/.local/bin/chezmoi update
fi

mkdir -p ~/.cache/zsh/evals

if [ "$SHELL" != "$(which zsh)" ]; then
	echo "Changing default shell to Zsh..."
	sudo chsh -s $(which zsh) $(whoami)
fi


echo "======================================================="
echo "Bootstrap complete!"

if [ "$IS_WSL" = true ]; then
    echo "1. Close Windows Terminal completely."
    echo "2. Run 'wsl --shutdown' from Windows PowerShell."
    echo "3. Open a new Ubuntu tab."
else
    echo "Please log out of your desktop session and log back in,"
    echo "or fully restart your terminal emulator to load Zsh."
fi
echo "======================================================="
