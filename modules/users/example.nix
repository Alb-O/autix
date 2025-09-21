let
  userName = "example";
in
{
  flake.modules.nixos.${userName} = {
    users.users.${userName} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
}
