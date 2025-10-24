{
  settings = {
    agent = {
      nixer = {
        disabled = false;
        description = ''
          Upstream nix researcher agent, give it a nix research task.
          IMPORTANT: You must ask it to use `mcp-nixos` tools in your description of the task.
          Ask it to be thorough and use the `mcp-nixos` tool many times, it will report back.
        '';
        mode = "subagent";
        prompt = ''
          Use the Mcp-Nixos tools (e.g. nixos_search, nixos_info, home_manager_search) to query up-to-date packages & options.
          Report back with correct technical details from official sources, or otherwise depending on your task.
        '';
        tools = {
          write = false;
          edit = false;
          patch = false;
          bash = false;
          webfetch = false;
          "atomic_*" = false;
          "mcp-nixos_*" = true;
        };
      };
      docfinder = {
        disabled = false;
        description = ''
          Technical documentation researcher agent, give it any techincal research task (e.g. libraries, APIs, languages).
          IMPORTANT: You must ask it to use `context7` tools in your description of the task.
          Ask it to be thorough and use the `context7` tools many times, it will report back.
        '';
        mode = "subagent";
        prompt = ''
          Use the Context7 tools (e.g. resolve_library_id, get_library_docs) to retrieve up-to-date technical docs relevant to your given task.
          Resolve library ID, then fetch docs with topics and token limits. Report back with detailed context and code examples from official sources.
        '';
        tools = {
          write = false;
          edit = false;
          patch = false;
          bash = false;
          webfetch = false;
          "atomic_*" = false;
          "context7_*" = true;
        };
      };
    };
  };
}
