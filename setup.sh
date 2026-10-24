#!/bin/bash

echo "[*] Updating system package databases..."
sudo pacman -Syu --noconfirm

echo "[*] Installing core development and terminal utilities..."
sudo pacman -S --noconfirm \
    base-devel \
    git \
    curl \
    wget \
    micro \
    htop \
    tmux

echo "[*] Installing audio infrastructure..."
sudo pacman -S --noconfirm \
    pipewire \
    pipewire-alsa \
    pipewire-pulse \
    wireplumber

echo "[*] Installing Python & package tools..."
sudo pacman -S --noconfirm python python-pip
python3 -c "print('Python is installed.')"
