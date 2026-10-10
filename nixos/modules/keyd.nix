{
  # caps = hold-to-control layer with hjkl navigation;
  # ctrl:nocaps in niri's xkb config stays as fallback when keyd is inactive
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          capslock = "layer(capsnav)";
        };
        "capsnav:C" = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
        };
      };
    };
  };
}
