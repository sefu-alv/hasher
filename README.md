# Reverse hash

A Bash script that attempts to identify and crack a password hash using `hashid` and `hashcat` with a supplied wordlist.

## Features

- Automatically detects possible hash types using `hashid`
- Extracts compatible Hashcat modes
- Iterates through each detected mode
- Attempts cracking using a specified wordlist
- Skips incompatible hash formats automatically
- Checks Hashcat potfile for previously cracked hashes
- Simple command-line usage

---

## Requirements

Install the following tools before using the script:

- `bash`
- `hashcat`
- `hashid`
- A wordlist (such as `rockyou.txt`)

### Debian/Ubuntu

```bash
sudo apt install hashcat hashid
```

### Wordlists

Common wordlists are typically stored in:

```bash
/usr/share/wordlists/
```

Example:

```bash
/usr/share/wordlists/rockyou.txt
```

---

## Usage

```bash
./script.sh -H <hash> -w <wordlist>
```

### Options

| Option | Description |
|--------|-------------|
| `-H` | Hash to crack |
| `-w` | Wordlist filename located in `/usr/share/wordlists/` |
| `-h` | Display help message |

---

## Example

```bash
./script.sh -H 5f4dcc3b5aa765d61d8327deb882cf99 -w rockyou.txt
```

Output:

```bash
Trying mode: 0
Cracked! Plaintext: password
```

---
## Script Breakdown

### Detect Possible Modes

```bash
modes=($(hashid -m $hash | grep -oP '(?<=Hashcat Mode: )\d+'))
```

Extracts all possible Hashcat mode IDs from `hashid`.

---

### Attempt Cracking

```bash
hashcat -D 1 --force -m "$mode" --quiet "$hash" /usr/share/wordlists/$wordoption
```

- `-D 1` → Use CPU device
- `--force` → Ignore warnings
- `-m` → Hashcat mode
- `--quiet` → Reduce output noise

---

### Detect Successful Crack

```bash
hashcat --show -m "$mode" "$hash"
```

Checks Hashcat’s potfile for cracked hashes.

---

## Notes

- The script assumes wordlists are located in:

```bash
/usr/share/wordlists/
```

- GPU cracking is disabled by default (`-D 1` uses CPU only)
- Some hashes may return multiple possible modes
- `--force` may suppress important warnings; use carefully

---

## Security Disclaimer

This script is intended for:

- Educational purposes
- Authorized password auditing
- Capture-the-flag (CTF) challenges
- Personal password recovery

Do not use this tool on systems or hashes you do not own or have explicit permission to test.

---

## Possible Improvements

- Add GPU support
- Support custom wordlist paths
- Add brute-force and rule-based attacks
- Improve hash-type validation
- Add colored terminal output
- Export results to a log file
