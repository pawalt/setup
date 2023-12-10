to install flakes:
```
https://serokell.io/blog/practical-nix-flakes
# for darwin just boot up
# nix --extra-experimental-features nix-command --extra-experimental-features flakes run nix-darwin -- switch --flake .
# for nixos just boot up
sudo nixos-rebuild switch --flake .
```
