{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.liquidprompt;
in
  with lib;
{
  options = {
    host.home.applications.liquidprompt = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Shell customization ";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          liquidprompt
        ];
    };

    programs = {
      bash = {
        initExtra = ''
          # Only load Liquidprompt in interactive shells, not from a script or from scp
          if [[ $- = *i* ]] ; then
             if [ -f /home/$USER/.nix-profile/bin/liquidprompt ]; then
                source /home/$USER/.nix-profile/bin/liquidprompt
             elif [ -f /home/$USER/.local/state/nix/profile/bin/liquidprompt ]; then
                source /home/$USER/.local/state/nix/profile/bin/liquidprompt
             fi
          fi
        '';
      };
    };

    xdg.configFile."liquidpromptrc".text = ''
      #############
      # BEHAVIOUR #
      #############

      # Display the battery level when the level is below this threshold.
      # Recommended value is 75
      LP_BATTERY_THRESHOLD=75

      # Display the load average when the load is above this threshold.
      # Recommended value is 60
      LP_LOAD_THRESHOLD=60

      # Display the temperature when the temperate is above this threshold (in
      # degrees Celsius).
      # Recommended value is 60
      LP_TEMP_THRESHOLD=70

      # Use the shorten path feature if the path is too long to fit in the prompt
      # line.
      # Recommended value is 1
      LP_ENABLE_SHORTEN_PATH=1

      # The maximum percentage of the screen width used to display the path before
      # removing the center portion of the path and replacing with '...'.
      # Recommended value is 35
      LP_PATH_LENGTH=35

      # The number of directories (including '/') to keep at the beginning of a
      # shortened path.
      # Recommended value is 2
      LP_PATH_KEEP=2

      # Determine if the hostname should always be displayed, even if not connecting
      # through network.
      # Defaults to 0 (do not display hostname when locally connected)
      # set to 1 if you want to always see the hostname
      # set to -1 if you want to never see the hostname
      LP_HOSTNAME_ALWAYS=1

      # Use the fully qualified domain name (FQDN) instead of the short hostname when
      # the hostname is displayed
      LP_ENABLE_FQDN=0

      # Always display the user name, even if the user is the same as the one logged
      # in.
      # Defaults to 1 (always display the user name)
      # set to 0 if you want to hide the logged user (it will always display different
      # users)
      LP_USER_ALWAYS=1

      # Display the percentages of load/batteries along with their
      # corresponding marks. Set to 0 to only print the colored marks.
      # Defaults to 1 (display percentages)
      #LP_PERCENTS_ALWAYS=1
      LP_DISPLAY_VALUES_AS_PERCENTS=1

      # Use the permissions feature and display a red ':' before the prompt to show
      # when you don't have write permission to the current directory.
      # Recommended value is 1
      LP_ENABLE_PERM=1

      # Enable the proxy detection feature.
      # Recommended value is 1
      LP_ENABLE_PROXY=0

      # Enable the jobs feature.
      # Recommended value is 1
      LP_ENABLE_JOBS=1

      # Enable the load feature.
      # Recommended value is 1
      LP_ENABLE_LOAD=1

      # Enable the battery feature.
      # Recommended value is 1
      LP_ENABLE_BATT=1

      # Enable the 'sudo credentials' feature.
      # Be warned that this may pollute the syslog if you don't have sudo
      # credentials, and the sysadmin will hate you.
      LP_ENABLE_SUDO=1

      # Enable the VCS features with the root account.
      # Recommended value is 0
      LP_ENABLE_VCS_ROOT=0

      # Enable the Git special features.
      # Recommended value is 1
      LP_ENABLE_GIT=1

      # Enable the Subversion special features.
      # Recommended value is 1
      LP_ENABLE_SVN=0

      # Enable the Mercurial special features.
      # Recommended value is 1
      LP_ENABLE_HG=0

      # Enable the Fossil special features.
      # Recommended value is 1
      LP_ENABLE_FOSSIL=0

      # Enable the Bazaar special features.
      # Recommanded value is 1
      LP_ENABLE_BZR=0

      # Show time of when the current prompt was displayed. (Must be enabled and
      # disabled in the config file and not after liquidprompt has already been
      # sourced.)
      LP_ENABLE_TIME=1

      # Show runtime of the previous command if over LP_RUNTIME_THRESHOLD
      # Recommended value is 0
      LP_ENABLE_RUNTIME=0

      # Minimal runtime (in seconds) before the runtime will be displayed
      # Recommended value is 2
      LP_RUNTIME_THRESHOLD=2

      # Display the virtualenv that is currently activated, if any
      # Recommended value is 1
      LP_ENABLE_VIRTUALENV=1

      # Display the enabled software collections, if any
      # Recommended value is 1
      LP_ENABLE_SCLS=0

      # Show average system temperature
      LP_ENABLE_TEMP=1

      # When showing the time, use an analog clock instead of numeric values.
      # The analog clock is "accurate" to the nearest half hour.
      # You must have a unicode-capable terminal and a font with the "CLOCK"
      # characters.
      # Recommended value is 0
      LP_TIME_ANALOG=0

      # Use the prompt as the title of the terminal window
      # The content is not customizable, the implementation is very basic,
      # and this may not work properly on exotic terminals, thus the
      # recommended value is 0
      # See LP_TITLE_OPEN and LP_TITLE_CLOSE to change escape characters to adapt this
      # feature to your specific terminal.
      LP_ENABLE_TITLE=1

      # Enable Title for screen and byobu
      LP_ENABLE_SCREEN_TITLE=1

      # Use different colors for the different hosts you SSH to
      LP_ENABLE_SSH_COLORS=1

      # Specify a list of complete and colon (":") separated paths in which, all vcs
      # will be disabled
      LP_DISABLED_VCS_PATH=""

    '';

  };
}
