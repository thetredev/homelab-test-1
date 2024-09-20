{ config, lib, meta, ... }:

{
  networking = {
    hostName = meta.hostname;
    useDHCP = lib.mkDefault true; # TODO: make this configurable
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 22 ];
  };
}
