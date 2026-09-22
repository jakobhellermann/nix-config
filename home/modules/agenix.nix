{ config, ... }:
{
  age = {
    identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

    secrets = {
      # sourced by ~/.config/fish/conf.d/agenix.fish
      user-env.file = ../../secrets/user-env.age;
      user-env.path = "${config.home.homeDirectory}/.local/state/agenix/user-env";
    };
  };
}
