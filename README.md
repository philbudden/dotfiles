# :hammer_and_wrench: My Dotfiles: Declarative Chaos, Elegantly Managed

Welcome to my dotfiles repo—a lovingly crafted mess of scripts, configs, and automation rituals designed to tame the wild beast that is cross-platform setup. If you're here, you're either me (hi future n3ddu8 👋), a curious engineer, or someone who clicked the wrong link. Either way, buckle up.

## :yawning_face: TLDR

```shell
curl -L https://nixos.org/nix/install | sh
. ~/.nix-profile/etc/profile.d/nix.sh
nix-env -iA nixpkgs.chezmoi
chezmoi init --apply $YOURGITHUBUSER
```

## :rocket: What This Is

This repo uses [chezmoi](https://www.chezmoi.io/) to manage my personal and professional environments across:

- :window: Windows
- :penguin: Linux (x86_64 + aarch64)
- :apple: macOS
- :shell: WSL2

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
- `host.nix`: Stuff I want everywhere that isn't a conatiner!

Install logic lives in `run_onchange_install-packages.sh.tmpl`, which chezmoi renders and runs when things change. It’s templated, declarative, and slightly cursed.

## :test_tube: Setup Instructions

1. **Install Nix**  
   ```shell
   curl -L https://nixos.org/nix/install | sh
   . ~/.nix-profile/etc/profile.d/nix.sh
   ```
   (you may need some prereqs dependong on how bare-bones your system is)
   ```shell
   sudo apt update && \
     sudo apt install curl xz-utils
   ```

2. **Install Chezmoi**
   ```shell
   nix-env -iA nixpkgs.chezmoi
   chezmoi init --apply $YOURGITHUBUSER
   ```

3. **Let the magic happen**</br>
Chezmoi will apply configs, detect WSL2 (if applicable), and run the install script to pull in packages via Nix.

4. **Profit**</br>
You now have bat, gh, neovim, ripgrep, starship, zoxide, and more. If you're on WSL2, you get extra goodies like Docker, Devpod, Ghostty, and tmux.

## :jigsaw: Future Plans

- Add support for macOS and native Linux setups.

- Introduce Homebrew (again) for macOS where Nix isn’t ideal.

- Maybe—just maybe—embrace Home Manager and Nix Darwin.

- Expand package definitions to include GUI apps, fonts, and other creature comforts.

- Refactor into a modular, layered architecture that reflects my engineering philosophy.

## :open_book: Notes

- `.chezmoiignore` ignores README.md because I don’t want chezmoi touching this masterpiece.

- `.chezmoidata` contains templated logic for detecting WSL2.

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

**Q:** Why is your .chezmoidata file trying to detect WSL2? 
**A:** Because WSL2 is a beautiful lie and I need to treat it like the special snowflake it is.

**Q:** Why not just use Docker for everything? 
**A:** Because I like my dotfiles to touch grass. Also, containers don’t solve existential dread.

**Q:** Why is your README so sarcastic? 
**A:** Because engineering is serious, but dotfiles are personal. This is my playground, not a compliance audit.

**Q:** Are you okay? 
**A:** Define “okay.” If by “okay” you mean “deep in a recursive dotfile refactor while debating the merits of ephemeral lock files,” then yes. If you mean “touching grass,” then no. But spiritually? I’m thriving.

Still reading? You’re either very bored or very interested. Either way, I salute you :vulcan_salute:.