# Firefox extensions configuration
# Managed extensions and their installation settings
{...}: {
  extensionSettings = {
    "addon@darkreader.org" = {
      # Dark Reader
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
      installation_mode = "force_installed";
    };
    "uBlock0@raymondhill.net" = {
      # uBlock Origin
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      installation_mode = "force_installed";
    };
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
      # BitWarden
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
      installation_mode = "force_installed";
    };
    "sponsorBlocker@ajay.app" = {
      # SponsorBlock
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
      installation_mode = "force_installed";
    };
    "clipper@obsidian.md" = {
      # Obsidian Clipper
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/obsidian-web-clipper/latest.xpi";
      installation_mode = "force_installed";
    };
    "7esoorv3@alefvanoon.anonaddy.me" = {
      # LibRedirect
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/libredirect/latest.xpi";
      installation_mode = "force_installed";
    };
    "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" = {
      # Violentmonkey
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/violentmonkey/latest.xpi";
      installation_mode = "force_installed";
    };
  };
}
