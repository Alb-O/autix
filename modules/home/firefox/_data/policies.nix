# Firefox policies configuration
# Security, privacy, and extension management
{...}: {
  policies = {
    AppAutoUpdate = false; # Disable automatic application update
    BackgroundAppUpdate = false; # Disable automatic application update in the background, when the application is not running.
    DisableBuiltinPDFViewer = true; # Considered a security liability
    DisableFirefoxStudies = true;
    DisableFirefoxAccounts = true; # Disable Firefox Sync
    DisableFirefoxScreenshots = true; # No screenshots?
    DisableForgetButton = true; # Thing that can wipe history for X time, handled differently
    DisableMasterPasswordCreation = true;
    DisableProfileImport = true; # Purity enforcement: Only allow nix-defined profiles
    DisableProfileRefresh = true; # Disable the Refresh Firefox button on about:support and support.mozilla.org
    DisableSetDesktopBackground = true; # Nix is the only thing that can manage the background
    DisplayMenuBar = "default-off";
    DisablePocket = true;
    DisableTelemetry = true;
    DisableFormHistory = true;
    DisablePasswordReveal = true;
    DontCheckDefaultBrowser = true; # Stop being attention whore
    HardwareAcceleration = true; # Enable for proper rendering and performance
    OfferToSaveLogins = false; # Managed by Bitwarden instead
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
      EmailTracking = true;
      # Exceptions = ["https://example.com"]
    };
    EncryptedMediaExtensions = {
      Enabled = true;
      Locked = true;
    };
    ExtensionUpdate = false;
  };
}
