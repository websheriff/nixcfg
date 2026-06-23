{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  stylix.targets.zen-browser.profileNames = [ "${config.home.username}" ];

  programs.zen-browser = {
    enable = true;
    languagePacks = [ "en-US" ];
    setAsDefaultBrowser = true;

    policies =
      let
        mkLockedAttrs = builtins.mapAttrs (
          _: value: {
            Value = value;
            Status = "locked";
          }
        );

        mkPluginUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";

        mkExtensionEntry =
          {
            id,
            pinned ? false,
          }:
          let
            base = {
              install_url = mkPluginUrl id;
              installation_mode = "force_installed";
            };
          in
          if pinned then base // { default_area = "navbar"; } else base;

        mkExtensionSettings = builtins.mapAttrs (
          _: entry: if builtins.isAttrs entry then entry else mkExtensionEntry { id = entry; }
        );
      in
      {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        SanitizeOnShutdown = {
          FormData = true;
          Cache = true;
        };
        ExtensionSettings = mkExtensionSettings {

        };
        Preferences = mkLockedAttrs {
          "browser.aboutConfig.showWarning" = false;
          "browser.tabs.warnOnClose" = false;
          "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;
          # Disable swipe gestures (Browser:BackOrBackDuplicate, Browser:ForwardOrForwardDuplicate)
          "browser.gesture.swipe.left" = "";
          "browser.gesture.swipe.right" = "";
          "browser.tabs.hoverPreview.enabled" = true;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.topsites.contile.enabled" = false;

          "privacy.resistFingerprinting" = true;
          "privacy.resistFingerprinting.randomization.canvas.use_siphash" = true;
          "privacy.resistFingerprinting.randomization.daily_reset.enabled" = true;
          "privacy.resistFingerprinting.randomization.daily_reset.private.enabled" = true;
          "privacy.resistFingerprinting.block_mozAddonManager" = true;
          "privacy.spoof_english" = 1;

          "privacy.firstparty.isolate" = true;
          "network.cookie.cookieBehavior" = 5;
          "dom.battery.enabled" = false;

          "gfx.webrender.all" = true;
          "network.http.http3.enabled" = true;
          "network.socket.ip_addr_any.disabled" = true; # disallow bind to 0.0.0.0
        };
      };

    # Use legacy profile mode to avoid needing machine-specific Install identifier
    #home.sessionVariables.MOZ_LEGACY_PROFILES = "1";

    profiles.${config.home.username} = rec {
      id = 0; # Profile IDs must be sequential starting from 0
      settings = {
        "zen.workspaces.continue-where-left-off" = true;
        "zen.workspaces.natural-scroll" = true;
        "zen.view.compact.hide-tabbar" = true;
        "zen.view.compact.hide-toolbar" = true;
        "zen.view.compact.animate-sidebar" = true;
        "zen.view.user-single-toolbar" = false;
        "zen.welcome-screen.seen" = true;
        "zen.urlbar.behavior" = "float";
        "ui.systemUsesDarkTheme" = 1;
      };

      keyboardShortcutsVersion = 19; # pin to detect regressions
      keyboardShortcuts = [
        {
          id = "zen-compact-mode-toggle";
          key = "s";
          modifiers.control = true;
          modifiers.alt = true;
        }
        {
          id = "zen-compact-mode-show-sidebar"; # toggle floating sideboar
          key = "f";
          modifiers.control = true;
          modifiers.alt = true;
        }
        {
          id = "key_savePage";
          key = "s";
          modifiers.control = true;
        }
        {
          id = "key_quitApplication";
          disabled = true;
        }
      ];

      pinsForce = true;
      pins = {
        "YouTube" = {
          id = "a67b68a9-537f-41fa-ba04-b7e5722e6c3b";
          #        workspace = spaces."Personal".id;
          url = "https://youtube.com";
          isEssential = true;
          position = 0;
        };
        "Rumble" = {
          id = "becffa75-0b0b-4e4e-be48-a4454389be5d";
          #       workspace = spaces."Personal".id;
          url = "https://rumble.com";
          isEssential = true;
          position = 1;
        };
        "Linkwarden" = {
          id = "85a60789-b57e-473b-a135-a2c649538051";
          #      workspace = spaces."Personal".id;
          url = "https://";
          isEssential = true;
          position = 2;
        };
        "Dashboard" = {
          id = "e15f4c62-61b8-44bf-8ba6-e66eb7e0a8ea";
          #     workspace = spaces."Personal".id;
          url = "https://github.com/notifications";
          isEssential = true;
          position = 3;
        };
      };

      search = {
        force = true;
        default = "ddg";
        engines =
          let
            nixSnowflakeIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          in
          {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = nixSnowflakeIcon;
              definedAliases = [ "p" ];
            };

            "Nix Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = nixSnowflakeIcon;
              definedAliases = [ "o" ];
            };

            "Home Manager Options" = {
              urls = [
                {
                  template = "https://home-manager-options.extranix.com/";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "release";
                      value = "master";
                    }
                  ];
                }
              ];
              icon = nixSnowflakeIcon;
              definedAliases = [ "hm" ];
            };

            "Google Maps" = {
              urls = [
                {
                  template = "http://maps.google.com";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = [
                "maps"
                "gmaps"
              ];
            };

            "DuckDuckGo" = {
              urls = [
                {
                  template = "https://duckduckgo.com";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                    {
                      name = "origin";
                      value = "unknown";
                    }
                  ];
                }
              ];
              definedAliases = [
                "duck"
                "ddg"
              ];
            };

            bing.metaData.hidden = "true";
          };
      };
    };
    # Open files with the browser
    #xdg.mimeApps =
    # let
    #  associations = builtins.listToAttrs (
    #   map
    #    (name: {
    #     inherit name;
    #    value = "zen-beta.desktop";
    #  })
    #  [
    #    "application/x-extension-shtml"
    #    "application/x-extension-xhtml"
    #    "application/x-extension-html"
    #    "application/x-extension-xht"
    #    "application/x-extension-htm"
    #    "x-scheme-handler/unknown"
    #    "x-scheme-handler/mailto"
    #    "x-scheme-handler/chrome"
    #    "x-scheme-handler/about"
    #    "x-scheme-handler/https"
    #    "x-scheme-handler/http"
    #    "application/xhtml+xml"
    #    "application/json"
    #    "text/plain"
    #    "text/html"
    # ]
    #);
    #in
    #{
    #  enable = true;
    #  associations.added = associations;
    #  defaultApplications = associations;
    #};
  };
}
