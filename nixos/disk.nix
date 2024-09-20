{ lib, ... }:
{
  disko.devices = {
    disk.disk1 = {
      device = lib.mkDefault "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              extraArgs = [ "-F" "32" ];
              mountpoint = "/boot";
            };
          };
          root = {
            name = "NIXOS";
            size = "100%";
            content = {
              type = "filesystem";
              format = "xfs";
              extraArgs = [ "-f" ];
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
