{
  settings = {
    agent = {
      nixer = {
        description = "Upstream Nix checker, uses specialized tools for quickly fetching up-to-date options";
        mode = "subagent";
        prompt = "Use the Mcp-Nixos tools (e.g. nixos_search, nixos_info, home_manager_search) to query up-to-date packages & options. Report back with correct technical details, or otherwise depending on your task.";
        tools = {
          write = false;
          edit = false;
          bash = false;
          "Mcp-Nixos*" = true;
        };
      };
      docfinder = {
        description = "Documentation finder, uses specialized tools to look up relevant/up-to-date technical docs";
        mode = "subagent";
        prompt = "Use the Context7 tools (e.g. resolve_library_id, get_library_docs) to retrieve up-to-date technical docs relevant to your given task. Resolve library ID, then fetch docs with topics and token limits. Report back with detailed context and code examples from official sources.";
        tools = {
          write = false;
          edit = false;
          bash = false;
          "Context7*" = true;
        };
      };
    };
  };
}
