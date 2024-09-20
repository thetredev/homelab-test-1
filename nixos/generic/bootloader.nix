{ config, lib, pkgs, ... }:

{
  boot = {
    loader = {
      timeout = lib.mkDefault 1;
      grub = {
        enable = true;
        efiSupport = false;
      };
      efi.canTouchEfiVariables = false;
    };

    # Latest kernel, please
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
