{ config, pkgs, ... }:

let
  toiSiteDir = "${config.home.homeDirectory}/src/web/toi/";
  toiSiteBuild = pkgs.writeShellScriptBin "webbuild_toi" ''
    pushd ${toiSiteDir}../ > /dev/null
    rm -rf public/*
    ${pkgs.hugo}/bin/hugo --ignoreCache --minify -v ;
    popd > /dev/null
  '';
  toiSiteDeploy = pkgs.writeShellScriptBin "webdeploy_toi" ''
    ${pkgs.openssh}/bin/ssh -t $(cat $XDG_RUNTIME_DIR/secrets/website_deploy/user)@$(cat $XDG_RUNTIME_DIR/secrets/website_deploy/toi) "rm -rf /var/local/data/$(cat $XDG_RUNTIME_DIR/secrets/website_deploy/toi)/data/*"
    ${pkgs.rsync}/bin/rsync -aXX ${cmSiteDir} $(cat $XDG_RUNTIME_DIR/secrets/website_deploy/user)@$(cat $XDG_RUNTIME_DIR/secrets/website_deploy/toi):/var/local/data/$(cat $XDG_RUNTIME_DIR/secrets/website_deploy/toi)/data/
  '';
  cmSiteDir = "${config.home.homeDirectory}/src/web/cm/";
  cmSiteBuild = pkgs.writeShellScriptBin "webbuild_cm" ''
    pushd ${cmSiteDir}../ > /dev/null
    rm -rf public/*
    ${pkgs.hugo}/bin/hugo --ignoreCache --minify -v ;
    popd > /dev/null
  '';
  cmSiteDeploy = pkgs.writeShellScriptBin "webdeploy_cm" ''
    ${pkgs.openssh}/bin/ssh -t $(cat $XDG_RUNTIME_DIR/secrets/website_deploy/user)@$(cat $XDG_RUNTIME_DIR/secrets/website_deploy/cm) "rm -rf /var/local/data/$(cat $XDG_RUNTIME_DIR/secrets/website_deploy/cm)/data/*"
    ${pkgs.rsync}/bin/rsync -aXX ${cmSiteDir} $(cat $XDG_RUNTIME_DIR/secrets/website_deploy/user)@$(cat $XDG_RUNTIME_DIR/secrets/website_deploy/cm):/var/local/data/$(cat $XDG_RUNTIME_DIR/secrets/website_deploy/cm)/data/
  '';
in {
  home = {
    packages = with pkgs;
      [
        hugo
        toiSiteBuild
        toiSiteDeploy
        cmSiteBuild
        cmSiteDeploy
      ];
  };

  sops.secrets = {
    "website_deploy/toi" = { sopsFile = ../../home/toi/secrets/website_deploy.yaml ; };
    "website_deploy/cm" = { sopsFile = ../../home/toi/secrets/website_deploy.yaml ; };
    "website_deploy/user" = { sopsFile = ../../home/toi/secrets/website_deploy.yaml ; };
  };
}


