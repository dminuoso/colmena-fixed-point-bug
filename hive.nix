{ 
  "foo" = { ... }: {
    config.networking.hostName = "foo";
  };
  "quux" = { config, lib, ... }: with lib; {
    users.motd = config.utils.allNodes.foo.config.networking.hostName;
  };
  
  "defaults" = { name, lib, nodes, ... }:
    {
        options.utils.allNodes = lib.mkOption {
            type = lib.types.anything;
            readOnly = true;
            default = nodes;
        };
        config = {
            boot.loader.grub.devices = ["/dev/sda"];
            system.stateVersion = "22.05";
            fileSystems."/" =
                { device = "/dev/disk/by-uuid/94dcf2a2-07c2-4095-a6d5-a8249230a04e";
                fsType = "ext4";
                };
            };
    };
}
