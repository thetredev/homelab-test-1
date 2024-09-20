{ self, config, lib, pkgs, meta, ... }:

let
  # System profile packages
  system_packages = with pkgs; [
    vim
    wget
    curl
    rsync
    bash-completion
    most
    ncdu
    file
    nettools
    bottom
    htop
  ];

in
{
  imports = lib.pipe ./generic [
    builtins.readDir
      (lib.filterAttrs (name: _: lib.hasSuffix ".nix" name))
      (lib.mapAttrsToList (name: _: ./generic + "/${name}"))
  ] ++ [
    ./machines/${meta.machine}.nix
  ];

  # Handy shortcuts
  programs.bash.shellAliases = {
    update-nix = "nix flake update /etc/nixos/#";
    reconfigure-nix = "nixos-rebuild switch --flake /etc/nixos/#default";
    reconfigure-boot = "nixos-rebuild boot --flake /etc/nixos/#default";
    cleanup-nix = "nix-collect-garbage -d && reconfigure-boot && fstrim -v /";
  };

  # Basic packages
  environment.systemPackages = system_packages;


  # ---------------------------------------------------------------
  # --------------- NEVER CHANGE THIS WHEN DEPLOYED ---------------
  # ---------------------------------------------------------------
  system.copySystemConfiguration = false;
  system.stateVersion = "24.05";
}
