# DE-Demo NixOS ISO

A NixOS ISO that includes all major desktop environments (DEs) in one image.

## Build

Build on any x86_64 system that supports the Nix package manager:

```$ nix build github:moontee/DE-demo#nixosConfigurations.iso.config.system.build.isoImage```

The ISO will be in: ```./result/iso/nixos-*.iso```
