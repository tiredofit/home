{config, lib, pkgs, ...}:
let
  cfg = config.host.home.applications.starship;
in
  with lib;
{
  options = {
    host.home.applications.starship = {
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
          #starship
        ];
    };

    programs = {
      bash = {
        #initExtra = ''
        #  if [[ $TERM != "dumb" ]]; then
        #    eval "$(${pkgs.starship}/bin/starship init bash --print-full-init)"
        #  fi
        #'';
        sessionVariables = {
          STARSHIP_CONFIG = "${config.programs.starship.configPath}";
        };

      };
      zsh = {
        #initContent = lib.mkOrder 1 ''
        #  if [[ $TERM != "dumb" ]]; then
        #    eval "$(${pkgs.starship}/bin/starship init zsh)"
        #  fi
        #'';
        sessionVariables = {
          STARSHIP_CONFIG = "${config.programs.starship.configPath}";
        };
      };
      starship = {
        enable = true;
        configPath = "${config.xdg.configHome}/starship/starship.toml";
        enableBashIntegration = mkDefault true;
        enableZshIntegration = mkDefault true;
        settings = {
          scan_timeout = 35;
          command_timeout = 700;
          add_newline = false;
          format = "$time\\[$username$hostname$directory\\] $character";
          right_format = "$php$nix_shell$docker_context$golang$direnv$memory_usage$battery";

          time = {
            disabled = false;
            format = "[$time]($style) ";
            time_format = "%T";
            style = "bold blue";
          };

          username = {
            style_user = "white bold";
            style_root = "black bold";
            format = "[$user]($style)";
            disabled = false;
            show_always = false;
          };

          hostname = {
            ssh_only = true;
            format = "[$ssh_symbol](bold blue)@[$hostname](bold yellow):";
            trim_at = ".";
            disabled = false;
          };

          directory = {
            truncation_length = 8;
            truncation_symbol = "…/";
            format = "[$path]($style)[$read_only]($read_only_style)";
          };

          character = {
            success_symbol = "[\\$](bold green)";
            error_symbol = "[✗](bold red)";
          };

          direnv = {
            disabled = false;
            format = "[$loaded/$allowed]($style)";
            symbol = "";
            style = "bold green";
            allowed_msg = "✅";
            denied_msg = "❌";
            loaded_msg = "●";
          };

          php = {
            format = "🐘";
          };

          nix_shell = {
            symbol = "❄️";
            format = "[$symbol$state]($style) ";
            impure_msg = "[I](bold red)";
            pure_msg = "[P](bold green)";
            unknown_msg = "[U](bold yellow)";
          };

          golang = {
            format = "🐹(bold cyan)";
          };

          docker_context = {
            disabled = false;
            format = "🐋 [$context](blue bold)";
            detect_files = [ "compose.yml" "compose.yaml" "docker-compose.yml" "docker-compose.yaml" "Dockerfile" "Containerfile" ];
          };

          memory_usage = {
            disabled = false;
            threshold = 70;
            style = "bold dimmed green";
            format = "$symbol [$''{ram}]($style) ";
          };

          battery = {
            full_symbol = "🔋 ";
            display = [
              { threshold = 10; style = "bold red"; }
              { threshold = 30; style = "bold yellow"; }
              { threshold = 50; style = "bold green"; }
            ];
          };

          cmd_duration = {
            min_time = 500;
            format = "[$duration](bold yellow)";
          };

          git_branch = {
            symbol = "🌱 ";
            truncation_length = 4;
            truncation_symbol = "";
            ignore_branches = [ "main" ];
          };

          git_commit = {
            commit_hash_length = 4;
            tag_symbol = "🔖 ";
          };

          git_state = {
            format = "[\\($state( $progress_current of $progress_total)\\)]($style) ";
          };

          git_metrics = {
            added_style = "bold blue";
          };

          git_status = {
            ahead = "⇡$''{count}";
            diverged = "⇕⇡$''{ahead_count}⇣$''{behind_count}";
            behind = "⇣$''{count}";
          };

          status = {
            style = "bg:blue";
            format = "[\\[$symbol$common_meaning$signal_name$maybe_int\\]]($style) ";
            map_symbol = true;
            disabled = false;
          };
        };
      };
    };
  };
}
