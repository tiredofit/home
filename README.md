#  🏠 $HOME 🏠

Here are my standalone [home-manager](https://nix-community.github.io/home-manager/) configuration files that are used on my NixOS systems and also other linux distribution systems.

This allows for home directory portability from machine to machine to configure once and enjoy a many times forward. If you are looking for NixOS _system_ configuration have a peek at my [NixOS Configurations](https://github.com/tiredofit/nixos-config).

If you would like to base your own configuration from this repository, you will need to be able to use [Nix flakes](https://nixos.wiki/wiki/Flakes).

**Highlights**:

- Flexible **roles** such as **workstation**, **server**, **kiosk**
- Deployment of secrets using **sops-nix**
- Highly configured desktop environments for **i3** **sway** and **hyprland**
- Some real interesting **bash scripts** for automating common tasks.
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
    - `sd`: Similar to the above org, just another org for isolation
    - `...`
- `modules`: Modules that are specific to this installation
  - `applications`: Applications and configurations
    - `cli`: Command line tools
    - `gui`: Programs with a graphical interface
  - `desktop`: Desktop environments
    - `applications`: Programs specific to desktop and window environments
    - `displayServer`: `x` or `wayland` configuration
    - `windowManager`: A variety of configurations depending on the type of window manager, or Desktop environment
  - `feature` - Switchable features
  - `service` - Daemons and services

## Usage

 used option `1`` (Standalone) of the  [home-manager](https://nix-community.github.io/home-manager/) installation guide. I documented it on my website here: [Tired of I.T! Home Manager Setup](https://notes.tiredofit.ca/books/linux/page/home-manager-setup). The quick steps were:

- Add Home Manager Channel

```
nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
nix-channel --update
```

- Logout and log back in to install

```
nix-shell '<home-manager>' -A install
```

- This will create a default configuration flie at `~/.config/home-manager/home.nix`. Lets get rid of it and clone this repository instead.

```
rm -rf ~/.config/home-manager
git clone https://github.com/tiredofit/dotfiles.git ~/.config/home-manager
```

- Activate the configuration

```
home-manager switch --flake ~/.config/home-manager/#<config> -v
```

### Keep it up to date

```
nix flake update ~/.config/home-manager
```

### Managing Secrets

I took some notes and documented the process of getting encrypted secrets created and keeping up to date on my website. [Tired of IT! Secrets Management](https://notes.tiredofit.ca/books/linux/page/secrets-management).

# License

Do you what you'd like and I hope that this inspires you for your own configurations as many others have myself.
