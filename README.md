# :hammer_and_wrench: My Dotfiles: Declarative Chaos, Elegantly Managed

Welcome to my dotfiles repo—a lovingly crafted mess of scripts, configs, and automation rituals designed to tame the wild beast that is cross-platform setup. If you're here, you're either me (hi future n3ddu8 👋), a curious engineer, or someone who clicked the wrong link. Either way, buckle up.

## :yawning_face: TLDR

Linux:
```shell
curl -L https://nixos.org/nix/install | sh
. ~/.nix-profile/etc/profile.d/nix.sh
nix-env -iA nixpkgs.chezmoi
chezmoi init --apply n3ddu8
```

MacOS:
```shell
xcode-select --install
curl -L https://nixos.org/nix/install | sh
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
nix-env -iA nixpkgs.chezmoi
chezmoi init --apply n3ddu8
```

Windows:
```shell
wsl --install
shutdown /r /t 0
```
- Once rebooted:
```shell
wsl --install Ubuntu-24.04
```
- Follow the onscreen prompts, once the WSL instance launches:
```shell
sudo apt update && sudo apt install curl xz-utils
curl -L https://nixos.org/nix/install | sh
. ~/.nix-profile/etc/profile.d/nix.sh
nix-env -iA nixpkgs.chezmoi
chezmoi init --apply n3ddu8
```

## :rocket: What This Is

This repo uses [chezmoi](https://www.chezmoi.io/) to manage my personal and professional environments across:

- :window: Windows (WSL2)
- :penguin: Linux (x86_64 + aarch64)
- :apple: macOS

It’s a work in progress, but the goal is simple: one command, full setup, zero regrets.

## :mage_man: Philosophy

Why Nix? Because I like my setups like I like my coffee: reproducible, cross-platform, and slightly over-engineered.

I started with Homebrew, but it turns out Linux aarch64 support is... aspirational. GUI apps? Also nope. So I pivoted to Nix—not because I wanted to summon the full wrath of the Nix community (“just use Home Manager!”), but because:

- It works on everything.
- It speaks architecture fluently.
- It lets me pretend I’m a wizard casting spells with `nix-env`.

Yes, I know about Home Manager and Nix Darwin. No, I’m not ready. Let me live.

## :package: Package Management

Packages are defined in `.chezmoidata/packages.yaml`, split into:

- `common.nix`: Stuff I want everywhere!
- `host.nix`: Stuff I want everywhere that isn't a container!
- `wsl2.nix`: Stuff I want in WSL2!
- `darwin.nix`: Stuff I want in macOS!

Install logic lives in `run_onchange_install-packages.sh.tmpl`, which chezmoi renders and runs when things change. It’s templated, declarative, and slightly cursed.

## :test_tube: Setup Instructions

1. **Install Pre-reqs**
   - On Linux (Debian derivitives) ensure pre-reqs are installed:
   ```shell
   sudo apt update && \
     sudo apt install curl xz-utils
   ```
   - On MacOS:
   ```shell
   xcode-select --install
   ```
2. **Install Nix**
   ```shell
   curl -L https://nixos.org/nix/install | sh
   ```
   You will need to refresh your shell to make the `nix-env` command available:
     - On Linux:
     ```shell
     . ~/.nix-profile/etc/profile.d/nix.sh
     ```
     - On MacOS:
     ```shell
     . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
     ```
3. **Install Chezmoi**
   ```shell
   nix-env -iA nixpkgs.chezmoi
   ```
4. **Let the magic happen**
   ```shell
   chezmoi init --apply $YOURGITHUBUSER
   ```

## :jigsaw: Future Plans

- Add support for Windows and native Linux setups.

- Introduce Homebrew (again) for macOS where Nix isn’t ideal.

- Expand package definitions to include GUI apps, fonts, and other creature comforts.

- Refactor into a modular, layered architecture that reflects my engineering philosophy.

- Maybe—just maybe—embrace Home Manager and Nix Darwin.

## :open_book: Notes

- `.chezmoiignore` ignores README.md because I don’t want chezmoi touching this masterpiece.

- `private_git_config` is where I keep my Git secrets. No peeking.

## :brain: Why This Matters

This isn’t just dotfiles—it’s a living, breathing reflection of my workflow rituals, engineering values, and refusal to settle for “close enough.” It’s declarative, reproducible, and built to scale across environments without losing its soul.

## :question: FAQ: Questions Nobody Asked But I Answered Anyway

**Q:** Why not just use Ansible? 
**A:** Because I like pain. Also because Ansible doesn’t speak Nix, and I’m trying to build a declarative utopia, not a YAML swamp.

**Q:** Why not use Home Manager like a normal Nix user? 
**A:** Because I’m not normal. I’m emotionally invested in scripting my own onboarding rituals. Also, I like knowing exactly which part of my setup broke.

**Q:** Why not use GUI tools? 
**A:** Because I believe in the terminal. If I wanted buttons, I’d be a frontend developer. (No shade. Okay, some shade.)

**Q:** Why is your install script templated in Go text format? 
**A:** Because chezmoi said so. I don’t make the rules—I just bend them until they fit.

**Q:** Why not just use one package manager? 
**A:** Because I live on the edge. Also because Nix is the only one that doesn’t cry when I switch from x86_64 to aarch64.

**Q:** Why are you using /mnt/c to detect WSL2? 
**A:** Because WSL2 is a beautiful lie and I need to treat it like the special snowflake it is.

**Q:** Why not just use Docker for everything? 
**A:** Because I like my dotfiles to touch grass. Also, containers don’t solve existential dread.

**Q:** Why is your README so sarcastic? 
**A:** Because engineering is serious, but dotfiles are personal. This is my playground, not a compliance audit.

**Q:** Are you okay? 
**A:** Define “okay.” If by “okay” you mean “deep in a recursive dotfile refactor while debating the merits of ephemeral lock files,” then yes. If you mean “touching grass,” then no. But spiritually? I’m thriving.

Still reading? You’re either very bored or very interested. Either way, I salute you :vulcan_salute:.
