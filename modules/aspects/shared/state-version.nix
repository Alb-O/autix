{
  flake.aspects."state-version" = {
    description = "Shared stateVersion policy.";
    nixos =
      _:
      {
        system.stateVersion = "24.11";
      };
    homeManager =
      _:
      {
        home.stateVersion = "24.11";
      };
  };
}
