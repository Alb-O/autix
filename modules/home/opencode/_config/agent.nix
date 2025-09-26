{
  settings = {
    agent = {
      nixer = {
        description = "Upstream Nix checker, uses mcp-nixos for quickly fetching up-to-date options";
        mode = "subagent";
        prompt = "Use the Mcp-Nixos tools (e.g. nixos_search, nixos_info, home_manager_search, etc.) to query up-to-date packages & options. Either fix existing broken Nix code or report back with correct available options, depending on your task.";
        tools = {
          "Mcp-Nixos*" = true;
        };
      };
    };
  };
}
