{
  description = "NixOS ISO with the 4 major desktops";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs:

  { 
    nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        (
        { lib, pkgs, modulesPath,... }:

        {
          imports = [
            (modulesPath + "/installer/cd-dvd/installation-cd-base.nix")
            (modulesPath + "/profiles/minimal.nix")
          ];
          specialisation = {
            gnome.configuration = {
              imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix") ];
              isoImage.prependToMenuLabel = lib.mkOverride 10 "1.";
              isoImage.appendToMenuLabel = lib.mkOverride 10 " GNOME (MacOs-like)";
              environment.systemPackages = with pkgs; [ 
                gnome-extension-manager
                gnomeExtensions.blur-my-shell
                gnomeExtensions.dash-to-dock
                gnomeExtensions.tray-icons-reloaded
                gnomeExtensions.gsconnect
                gnomeExtensions.clipboard-indicator
              ];
  
              programs.dconf.profiles = {
                user.databases = [{
                  settings = with lib.gvariant; {
                    "org/gnome/shell".enabled-extensions = [
                      "blur-my-shell@aunetx"
                      "clipboard-indicator@tudmotu.com"
                      "dash-to-dock@micxgx.gmail.com"
                      "gsconnect@andyholmes.github.io"
                      "trayIconsReloaded@selfmade.pl"
                    ];
                    
                    "org/gnome/desktop/background".picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/geometrics-l.jxl";
                    "org/gnome/desktop/background".picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/geometrics-d.jxl";
                    "org/gnome/desktop/wm/preferences".button-layout = "appmenu:minimize,maximize,close";
                  };
                }];
              };
            };
    
            kde.configuration = {
              imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix") ];
              isoImage.prependToMenuLabel = lib.mkOverride 10 "2.";
              isoImage.appendToMenuLabel = lib.mkOverride 10 " KDE Plasma (Windows like)";
            };
    
            cinnamon.configuration = {
              imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-graphical-calamares.nix") ];
              services.displayManager.autoLogin.user = "nixos";
              services.displayManager.autoLogin.enable = true;
              services.xserver.displayManager.lightdm.enable = true;
              services.xserver.desktopManager.cinnamon.enable = true;
              services.cinnamon.apps.enable = true;
              isoImage.prependToMenuLabel = lib.mkOverride 10 "3.";
              isoImage.appendToMenuLabel = lib.mkOverride 10 " Cinnamon (Windows like)";
            };
    
            xfce.configuration = {
              imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-graphical-calamares.nix") ];
              services.displayManager.autoLogin.user = "nixos";
              services.displayManager.autoLogin.enable = true;
              services.xserver.displayManager.lightdm.enable = true;
              services.xserver.desktopManager.xfce.enable = true;
              isoImage.prependToMenuLabel = lib.mkOverride 10 "4.";
              isoImage.appendToMenuLabel = lib.mkOverride 10 " XFCE (Light Weight)";
            };
    
          };
          
          documentation.man.enable = lib.mkOverride 500 true;
          documentation.doc.enable = lib.mkOverride 500 true;
  
          environment.systemPackages = with pkgs; [
            firefox
              vlc
              libreoffice
              rhythmbox
              obs-studio
              neovim
          ];
  
          fonts.fontconfig.enable = lib.mkOverride 500 false;
          fonts.packages = [ pkgs.adwaita-fonts ];
  
          isoImage.appendToMenuLabel = lib.mkOverride 500 " CLI";
          isoImage.grubTheme = lib.mkOverride 500 (
              pkgs.callPackage "${pkgs.path}/pkgs/by-name/sl/sleek-grub-theme/package.nix" {
              withStyle = "dark";
              withBanner = "MEOWERS";
          });
          isoImage.edition = lib.mkOverride 500 "calden";
          
          })
      ];
    };
  };
}
