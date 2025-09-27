# Firefox profile configuration
# Settings, UI customization, and feature toggles
{ lib, downloadDir, ... }:
{
  profileSettings = {
    "browser.startup.homepage" = "about:home";

    # Disable irritating first-run stuff
    "browser.disableResetPrompt" = true;
    "browser.download.panel.shown" = true;
    "browser.feeds.showFirstRunUI" = false;
    "browser.messaging-system.whatsNewPanel.enabled" = false;
    "browser.rights.3.shown" = true;
    "browser.shell.checkDefaultBrowser" = false;
    "browser.shell.defaultBrowserCheckCount" = 1;
    "browser.startup.homepage_override.mstone" = "ignore";
    "browser.uitour.enabled" = false;
    "startup.homepage_override_url" = "";
    "trailhead.firstrun.didSeeAboutWelcome" = true;
    "browser.bookmarks.restore_default_bookmarks" = false;
    "browser.bookmarks.addedImportButton" = true;
    "browser.download.dir" = downloadDir;

    # Disable crappy home activity stream page
    "browser.newtabpage.activity-stream.feeds.topsites" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
    "browser.newtabpage.blocked" = lib.genAttrs [
      # Youtube
      "26UbzFJ7qT9/4DhodHKA1Q=="
      # Facebook
      "4gPpjkxgZzXPVtuEoAL9Ig=="
      # Wikipedia
      "eV8/WsSLxHadrTL1gAxhug=="
      # Reddit
      "gLv0ja2RYVgxKdp0I5qwvA=="
      # Amazon
      "K00ILysCaEq8+bEqV/3nuw=="
      # Twitter
      "T9nJot5PurhJSy8n038xGA=="
    ] (_: 1);

    # Disable some telemetry
    "app.shield.optoutstudies.enabled" = false;
    "browser.discovery.enabled" = false;
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "browser.ping-centre.telemetry" = false;
    "datareporting.healthreport.service.enabled" = false;
    "datareporting.healthreport.uploadEnabled" = false;
    "datareporting.policy.dataSubmissionEnabled" = false;
    "datareporting.sessions.current.clean" = true;
    "devtools.onboarding.telemetry.logged" = false;
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.hybridContent.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.prompted" = 2;
    "toolkit.telemetry.rejected" = true;
    "toolkit.telemetry.reportingpolicy.firstRun" = false;
    "toolkit.telemetry.server" = "";
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.unifiedIsOptIn" = false;
    "toolkit.telemetry.updatePing.enabled" = false;

    "identity.fxaccounts.enabled" = false; # Disable fx accounts
    "signon.rememberSignons" = false; # Disable "save password" prompt

    # Harden
    "privacy.trackingprotection.enabled" = true;
    "dom.security.https_only_mode" = false; # Disable to allow HTTP sites during troubleshooting

    # Layout
    "browser.uiCustomization.state" = builtins.readFile ./ui-customization-state.json;
    "browser.uidensity" = 1; # Compact mode

    # Enable sidebar/vertical tabs
    "sidebar.visibility" = "always-show";
    "sidebar.position_start" = true;
    "sidebar.revamp" = true;
    "sidebar.verticalTabs" = true;
    "sidebar.main.tools" = "aichat,bookmarks,history";

    # Use XDG portal
    "widget.use-xdg-desktop-portal.file-picker" = true;

    # Restore session on startup
    "browser.startup.page" = 3;
    "privacy.clearOnShutdown.history" = false;
    "privacy.clearOnShutdown.downloads" = false;
    "privacy.clearOnShutdown.sessions" = false;
    "privacy.clearOnShutdown.cache" = false;
    "privacy.clearOnShutdown.cookies" = false;

    "browser.aboutConfig.showWarning" = false; # Disable about:config warning
    "extensions.autoDisableScopes" = 0; # Enable extensions automatically

    # Ensure NixOS-managed settings take priority
    "general.config.filename" = "nixos-firefox.cfg";
    "general.config.obscure_value" = 0;
    "general.config.sandbox_enabled" = false;

    # Prevent Firefox from overriding NixOS-managed settings
    "browser.preferences.instantApply" = false;
    "browser.preferences.animateFadeIn" = true;

    # Force profile consistency
    "browser.profiles.updateCheckIntervalMS" = 0;
    "browser.migration.version" = 999;

    # Enable smooth scrolling
    "apz.overscroll.enabled" = true; # DEFAULT NON-LINUX
    "general.smoothScroll" = true; # DEFAULT
    "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;
    "general.smoothScroll.msdPhysics.enabled" = true;
    "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
    "general.smoothScroll.msdPhysics.regularSpringConstant" = 650;
    "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 25;
    "general.smoothScroll.msdPhysics.slowdownMinDeltaRatio" = "2";
    "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;
    "general.smoothScroll.currentVelocityWeighting" = "1";
    "general.smoothScroll.stopDecelerationWeighting" = "1";
    "mousewheel.default.delta_multiplier_y" = 300; # 250-400;
    "general.autoScroll" = true; # Middle-click scrolling

    # Enable userChrome.css for custom styling (disabled)
    #"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  };
}
