{ 
  "foo" = { ... }: {
    config.networking.hostName = "foo";
    config.deployment.tags = ["fun"];
  };
  "bar" = { ... }: {
    config.networking.hostName = "bar";
    config.deployment.tags = ["fun"];
  };
  "quux" = { config, lib, ... }: with lib; {
    users.motd = concatStringsSep "\n" (
      mapAttrsToList (_n: h: h.config.networking.hostName) config.utils.allNodes
    );
  };
  
  "defaults" = { name, lib, nodes, ... }:
    {
        options.utils.allNodes = lib.mkOption {
            type = lib.types.anything;
            description = "Return all nodes that match the specified role";
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
