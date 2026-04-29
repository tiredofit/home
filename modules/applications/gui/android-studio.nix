{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.android-studio;
  sdkPath = "${config.home.homeDirectory}/.android/sdk";
in
  with lib;
{
  options = {
    host.home.applications.android-studio = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Android Studio IDE";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        android-studio
      ];
      # Override ANDROID_HOME to point to our real (non-top-level-symlink) directory
      sessionVariables = {
        ANDROID_HOME = lib.mkForce sdkPath;
        ANDROID_SDK_ROOT = lib.mkForce sdkPath;
      };
    };

    android-sdk = {
      enable = true;
      packages = sdk: with sdk; [
        build-tools-36-1-0
        #build-tools-37-0-0
        cmdline-tools-latest
        emulator
        platform-tools
        platforms-android-36-1
        #platforms-android-37-0
        sources-android-36-1
        #sources-android-37-0
        system-images-android-36-1-google-apis-playstore-x86-64
        #system-images-android-37-0-google-apis-playstore-ps16k-x86-64
      ];
    };

    # Build ~/.android/sdk as a REAL directory (not a symlink to nix store) with individual per-component symlinks inside.
    # This stops Android Studio from resolving the top-level path to a nix store hash.
    home.activation.androidRealSdkDir = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      _nix_sdk=$(readlink -f "$HOME/.local/share/android" 2>/dev/null)
      if [ -n "$_nix_sdk" ] && [ -d "$_nix_sdk" ]; then
        # If ~/.android/sdk exists as a plain symlink (from a previous config), remove it
        if [ -L "$HOME/.android/sdk" ]; then
          rm "$HOME/.android/sdk"
        fi
        mkdir -p "$HOME/.android/sdk"
        # Remove stale symlinks for components that no longer exist
        for _link in "$HOME/.android/sdk"/*/; do
          [ -L "''${_link%/}" ] && [ ! -e "''${_link%/}" ] && rm "''${_link%/}"
        done
        # Create/update symlinks for each SDK component
        for _comp in "$_nix_sdk"/*/; do
          _name=$(basename "$_comp")
          ln -sfn "$_comp" "$HOME/.android/sdk/$_name"
        done
      fi
    '';

    # Ensure Android Studio config always points to ~/.android/sdk
    home.activation.androidStudioSdkConfig = lib.hm.dag.entryAfter [ "androidRealSdkDir" ] ''
      _as_config="$HOME/.config/Google/AndroidStudio2025.3.3/options/jdk.table.xml"
      mkdir -p "$(dirname "$_as_config")"
      if ! grep -q "$HOME/.android/sdk" "$_as_config" 2>/dev/null; then
        cat > "$_as_config" <<JDKEOF
<application>
  <component name="ProjectJdkTable">
    <jdk version="2">
      <name value="Android API 36 Platform" />
      <type value="Android SDK" />
      <homePath value="$HOME/.android/sdk" />
      <roots>
        <annotationsPath>
          <root type="composite">
            <root url="jar://$HOME/.android/sdk/platforms/android-36/data/annotations.zip!/" type="simple" />
          </root>
        </annotationsPath>
        <classPath>
          <root type="composite">
            <root url="jar://$HOME/.android/sdk/platforms/android-36/android.jar!/" type="simple" />
            <root url="file://$HOME/.android/sdk/platforms/android-36/data/res" type="simple" />
          </root>
        </classPath>
        <javadocPath>
          <root type="composite">
            <root url="http://developer.android.com/reference/" type="simple" />
          </root>
        </javadocPath>
        <sourcePath>
          <root type="composite" />
        </sourcePath>
      </roots>
      <additional sdk="android-36" />
    </jdk>
  </component>
</application>
JDKEOF
      fi
    '';
  };
}
