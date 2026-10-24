import os

homefolder = os.path.expanduser("~/")
bash_aliases = os.path.join(homefolder, ".bash_aliases")

print("--- QAC (Quick Alias Controller) ---")
print("1. Create alias")
print("2. Destroy alias")
mode = input("Choose mode (1 or 2): ").strip()

if mode == "1":
    # --- CREATE MODE ---
    key = input("Alias = ")
    command = input("Command = ")
    
    # Escape any single quotes in the command so they don't break Bash syntax
    safe_command = command.replace("'", "'\\''")

    try:
        # Append mode ("a") creates the file automatically if it's missing
        with open(bash_aliases, "a") as f:
            f.write(f"alias {key}='{safe_command}'\n")
            
        print(f"\nSuccessfully added alias '{key}' to .bash_aliases!")
        print("Run 'source ~/.bash_aliases' in your terminal to apply it.")

    except Exception as e:
        print(f"An error occurred: {e}")

elif mode == "2":
    # --- DESTROY MODE ---
    if not os.path.exists(bash_aliases):
        print(f"\nCould not find .bash_aliases at: {bash_aliases}")
    else:
        # Read all existing lines
        with open(bash_aliases, "r") as f:
            lines = f.readlines()
            
        if not lines:
            print("\nYour .bash_aliases file is currently empty.")
        else:
            print("\nCurrent Aliases:")
            print("-" * 30)
            for index, line in enumerate(lines, start=1):
                print(f"{index}: {line.strip()}")
            print("-" * 30)
            
            choice = input("Enter the line number of the alias you want to destroy: ")
            
            try:
                line_idx = int(choice) - 1
                
                if 0 <= line_idx < len(lines):
                    removed_line = lines.pop(line_idx) # Remove the chosen line from the list
                    
                    # Rewrite the file with the line removed (using 'w' mode to overwrite)
                    with open(bash_aliases, "w") as f:
                        f.writelines(lines)
                        
                    print(f"\nSuccessfully removed: {removed_line.strip()}")
                    print("Run 'source ~/.bash_aliases' in your terminal to apply it.")
                else:
                    print("\nInvalid line number. Please try again.")
                    
            except ValueError:
                print("\nInvalid input. Please enter a valid number.")
else:
    print("\nInvalid choice. Please run the script again and choose 1 or 2.")