import argparse
import re
import sys

def update_namelist(filename, updates):
    """
    Updates parameters in a Fortran namelist file.
    updates: dict of {key: value}
    """
    try:
        with open(filename, 'r') as f:
            lines = f.readlines()
    except FileNotFoundError:
        print(f"Error: File {filename} not found.")
        sys.exit(1)

    new_lines = []
    for line in lines:
        updated_line = line
        # Check if line contains any of the keys
        for key, value in updates.items():
            # Regex to match "key = value" or "key=value", case insensitive
            # Ignores comments starting with !
            # Captures the value part to replace it
            pattern = re.compile(r'^\s*' + re.escape(key) + r'\s*=\s*([^!]+)(.*)', re.IGNORECASE)
            match = pattern.match(line)
            if match:
                current_val = match.group(1).strip()
                comment = match.group(2)
                # Replace the value
                updated_line = line.replace(current_val, str(value), 1)
                print(f"Updated {key}: {current_val} -> {value}")
                break # Only update one key per line
        new_lines.append(updated_line)

    with open(filename, 'w') as f:
        f.writelines(new_lines)

def main():
    parser = argparse.ArgumentParser(description="Update Fortran namelist parameters.")
    parser.add_argument('filename', help="Path to the namelist file")
    parser.add_argument('--set', nargs=2, action='append', help="Key and Value to update (e.g. --set dt 3600)")
    
    args = parser.parse_args()

    if args.set:
        updates = {k: v for k, v in args.set}
        update_namelist(args.filename, updates)
    else:
        print("No updates specified.")

if __name__ == "__main__":
    main()
