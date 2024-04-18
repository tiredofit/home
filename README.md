#  🏠 $HOME 🏠

Here are my standalone [home-manager](https://nix-community.github.io/home-manager/) configuration files that are used on my NixOS systems and also other linux distribution systems.

This allows for home directory portability from machine to machine to configure once and enjoy a many times forward. If you are looking for NixOS _system_ configuration have a peek at my [NixOS Configurations](https://github.com/tiredofit/nixos-config).

If you would like to base your own configuration from this repository, you will need to be able to use [Nix flakes](https://nixos.wiki/wiki/Flakes).

**Highlights**:

- Flexible **roles** such as **workstation**, **server**, **kiosk**
- Deployment of secrets using **sops-nix**
- Highly configured desktop environments for **i3** **sway** and **hyprland**
- Some interesting **bash scripts** for automating common tasks.
- **Declarative** **themes** and **wallpapers** with **nix-colors**

- I ~sort of~ totally spent the summer of 2023 moving into this configuration after waving a fond farewell to near 2 decades of running Arch Linux. This, as with life, is still WIP. I documented the process on the [Tired of IT! NixOS](https://notes.tiredofit.ca/books/linux/chapter/nixos) chapter on my website.

## Tree Structure

- `flake.nix`: Entrypoint for home configurations.
- `dotfiles`: Configuration files that are outside of the Home-Manager configuration (not migrated to nix)
- `home`: Home Manager Configurations, accessible via `home-manager switch --flake `.
  - Split in between 'orgs' and common configuration this creates isolation. Based on 'roles' defaults are loaded
    and then each subfolder creates a different level of configuration specific to that host or role.
    - `common`: Shared configurations consumed by all users.
      - `role`: Files related to what "role" is being selected as a template
      - `secrets`: Secrets that are available to all users
    - `generic`: The 'generic' org to allow for isolation of configurations, secrets and config from various clients
    - `toi`: The 'toi' org to allow for isolation of configurations, secrets and config from various clients
      - `secrets`: Secrets that are specific to the 'toi' org
      - `<hostname>`: Optional subfolder to load more configuration files based on the home-manager profiles name
      - `<role>`: Optional subfolder to load more configuration files based on the roles name
      - `<users>`: Load some specific user profile information
    - `sd`: Similar to the above org, just another org for isolation
    - `sr`: Similar to the above org, just another org for isolation
    - `...`
- `modules`: Modules that are specific to this installation
  - `applications`: Applications and configurations
    - `cli`: Command line tools
    - `gui`: Programs with a graphical interface
  - `desktop`: Desktop environments
    - `displayServer`: `x` or `wayland` configuration
    - `utils`: Programs specific to desktop and window environments
      - `agnostic` - runs great on whatever window manager
      - `wayland` - wayland specific utilities to complement window managers
      - `x` - x specific utilties to complement window managers
    - `windowManager`: A variety of configurations depending on the type of window manager, or Desktop environment
  - `feature` - Switchable features
  - `service` - Daemons and services

## Usage

I used nix flakes in a system that had a multi user installation of Nix. I documented it on my website here: [Tired of I.T! Home Manager Setup](https://notes.tiredofit.ca/books/linux/page/home-manager-setup). The quick steps were:

- Initialize Home Manager

```
nix --extra-experimental-features "nix-command flakes" run home-manager/master --init
```

- Activate the Configuration

```
home-manager switch --flake .#${HOSTNAME}.${USERNAME} --extra-experimental-features 'nix-command flakes'
```

### Keep it up to date

```
nix flake update .
```

### Managing Secrets

I took some notes and documented the process of getting encrypted secrets created and keeping up to date on my website. [Tired of IT! Secrets Management](https://notes.tiredofit.ca/books/linux/page/secrets-management).

# License

Do you what you'd like and I hope that this inspires you for your own configurations as many others have myself.
