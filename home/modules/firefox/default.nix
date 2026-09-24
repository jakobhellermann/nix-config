{
  programs.firefox = {
    enable = true;
    policies = import ./policies.nix;
  };
}
