# :muscle: More Than Just Dotfiles

Welcome to the repo where dotfiles go to evolve, packages get installed without drama, and Chezmoi becomes the declarative deity of your system setup. If you're here expecting a humble .bashrc and a couple of aliases, you're in for a surprise. This is not a dotfiles repo. This is a lifestyle.

## :rocket: What Is This?

This repo uses Chezmoi as the single source of truth for:

- :open_file_folder: Dotfiles (obviously)
- :package: Package management (Homebrew, apt, pip, flatpak, and even GitHub CLI extensions)
- :brain: Declarative system setup across multiple profiles
- :airplane: Preflight checks that actually do something
- :thread: Modular YAML-driven orchestration that would make Ansible blush

## :jigsaw: How It Works (Semi-Seriously)

Chezmoi reads from a constellation of .chezmoidata/*.yaml files to determine what packages to install, which managers to use, and how to behave based on your machine’s hostname. It’s like Hogwarts for sysadmins.

### :file_folder: `.chezmoidata/commands.yaml`

Defines how each package manager installs things. Think of it as the sacred scroll of install incantations:
```yaml
brew:
  install:
  - brew install
gh:
  preflight: |
    if ! gh auth status &>/dev/null; then
      echo "🔐 GitHub CLI not authenticated. Initiating login..."
      ...
    fi
  install:
  - gh extension install
```
Yes, we run preflight checks. Yes, they’re real. Yes, they involve ssh-keyscan. You're welcome.

### :construction_worker: `.chezmoidata/managers.yaml`

Maps logical groups to their respective package managers.
```yaml
package-managers:
  common:
  - brew
  - gh
  - pip
```
Each group, like common, macdaddy (yes, macdaddy is a profile, no I won’t apologise, naming things is hard, laughing at them is easy), winlinux etc, gets its own set of managers. It’s like Hogwarts houses, but for install commands.

### :package: `.chezmoidata/packages.yaml`

Specifies what each group should install with each manager. You fill in the blanks. I won’t judge your choice of CLI tools.
```yaml
packages:
  common:
    brew:
    - htop
    - jq
    gh:
    - copilot
    pip:
    - rich
```
### :dna: `.chezmoidata/profiles.yaml`

Maps hostnames to profiles. Profiles are just bundles of groups. Groups are bundles of packages. Packages are bundles of joy.
```yaml
profiles:
  macdaddy:
  - macdaddy
  devcontainer:
  - common
```
Your hostname determines your destiny. If it’s not found, you get the devcontainer profile. It’s like the sorting hat, but with fewer hats.

### :hammer_and_wrench: `run_onchange-install-packages.sh.tmpl`

This is the bash-powered engine that ties it all together. It:

1. Resolves your profile based on hostname
2. Loops through each group
3. Runs preflight checks (once per manager)
4. Installs packages with the correct command
5. Logs everything with emoji-powered commentary

```shell
echo "🚀 Applying profile for: {{ $profile }}"
echo -n "📦 Resolved groups:"
...
echo "🔧 Processing group: {{ $group }}"
```

## :thinking: Why Chezmoi?

Because Ansible is overkill, Bash is underkill, and Chezmoi is just right. It’s reproducible, declarative, and doesn’t make you write 200 lines of YAML to install htop.

## :thought_balloon: Final Thoughts

This repo is designed to be:

- Atomic (no manual steps)
- Reproducible (same result every time)
- Declarative (YAML all the way down)
- Playful (because life’s too short for boring dotfiles)
