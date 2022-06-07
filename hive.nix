{ 
  "foo" = { ... }: {
    config.networking.hostName = "foo";
    config.deployment.tags = ["fun"];
  };
  "bar" = { ... }: {
    config.networking.hostName = "bar";
    config.deployment.tags = ["fun"];
  };
  "quux" = { lib, config, ... }: {
    users.motd = lib.concatStringsSep "\n" (lib.mapAttrsToList (_name: host:
      host.config.networking.hostName
    ) (config.utils.nodesWithTag "fun"));
  };
  
  "defaults" = { name, lib, nodes, ... }:
    let
        utils = rec {
            nodesWithTag = tag: lib.filterAttrs (_name: host:
            builtins.elem tag host.config.deployment.tags
            ) nodes;
        };
    in {
        options.utils.nodesWithTag = lib.mkOption {
            type = with lib.types; anything;
            description = "Return all nodes that match the specified role";
            readOnly = true;
            default = utils.nodesWithTag;
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
