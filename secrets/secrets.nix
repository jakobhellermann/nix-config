let
  user_jakob = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB/7y7H/M64OslBJvrMA+s+eF1P4MJVf0hx/Gw4zoQXC jakob@me";
  user_sipgatejj = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/s4OVz67odrG1c2tww9XBoeZmv2on2bEo+qao81mt0 sipgatejj";
  users = [
    user_jakob
    user_sipgatejj
  ];

  # system_<hostname> = "ssh-ed25519 AAAA... root@<hostname>";

  names = [
    "user-env"
  ];
in
builtins.listToAttrs (
  map (name: {
    name = name + ".age";
    value = {
      publicKeys = users;
      armor = true;
    };
  }) names
)
