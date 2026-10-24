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
python3 -c "print('[*] Python is installed.')"
echo "[*]Setting up QoL commands and QAC."
python3 << 'EOF'
import os

homefolder = os.path.expanduser("~/")
bashrc = os.path.join(homefolder, ".bashrc")
text_attach = """
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
""".strip()

try:
   	 # Append mode ("a") creates the file automatically if it's missing
    with open(bashrc, "a") as f:
        f.write(f"\n{text_attach}")
        f.write("\n\nalias qac='python3 ~/.qac.py'")

except Exception as e:
    print(f"An error occurred: {e}")
EOF

echo "[*] Creating ~/.qac.py..."
python3 << 'EOF'
import os

qac_code = """import os

homefolder = os.path.expanduser("~/")
bash_aliases = os.path.join(homefolder, ".bash_aliases")

print("--- QAC (Quick Alias Controller) ---")
print("1. Create alias")
print("2. Destroy alias")
mode = input("Choose mode (1 or 2): ").strip()

if mode == "1":
    key = input("Alias = ")
    command = input("Command = ")
    safe_command = command.replace("'", "'\\''")
    try:
        with open(bash_aliases, "a") as f:
            f.write(f"alias {key}='{safe_command}'\\n")
        print(f"\\nSuccessfully added alias '{key}' to .bash_aliases!")
        print("Run 'source ~/.bash_aliases' to apply it.")
    except Exception as e:
        print(f"An error occurred: {e}")

elif mode == "2":
    if not os.path.exists(bash_aliases):
        print(f"\\nCould not find .bash_aliases at: {bash_aliases}")
    else:
        with open(bash_aliases, "r") as f:
            lines = f.readlines()
        if not lines:
            print("\\nYour .bash_aliases file is empty.")
        else:
            print("\\nCurrent Aliases:")
            print("-" * 30)
            for index, line in enumerate(lines, start=1):
                print(f"{index}: {line.strip()}")
            print("-" * 30)
            choice = input("Enter line number to destroy: ")
            try:
                line_idx = int(choice) - 1
                if 0 <= line_idx < len(lines):
                    removed_line = lines.pop(line_idx)
                    with open(bash_aliases, "w") as f:
                        f.writelines(lines)
                    print(f"\\nSuccessfully removed: {removed_line.strip()}")
                else:
                    print("\\nInvalid line number.")
            except ValueError:
                print("\\nInvalid input.")
else:
    print("\\nInvalid choice.")
"""

qac_path = os.path.expanduser("~/.qac.py")
with open(qac_path, "w") as f:
    f.write(qac_code)
print("[*] Successfully generated ~/.qac.py")
EOF

source ~/.bashrc