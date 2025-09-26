depending on how bare-bones your install is, you may need to install some pre-reqs:
```shell
sudo apt update && \
  sudo apt install curl xz-utils
```
then:
```shell
curl -L https://nixos.org/nix/install | sh
. ~/.nix-profile/etc/profile.d/nix.sh
nix-env -iA nixpkgs.chezmoi
chezmoi init --apply $YOURGITHUBUSER
```
