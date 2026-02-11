{inputs, ...}: {
  additions = final: _prev: import ../pkgs final.pkgs;

  modifications = final: prev: {
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.stdenv.hostPlatform.system;
      #system = final.system;
      config.allowUnfree = true;
    };
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      #system = final.system;
      config.allowUnfree = true;
    };
  };
}
