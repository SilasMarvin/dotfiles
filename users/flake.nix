{
  description = "Home manager flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nur.url = "github:nix-community/NUR";
    taffybar.url = "github:sherubthakur/taffybar";
  };

  outputs = { self, nur, taffybar, ... }@inputs:
    let
      missingVimPluginsInNixpkgs = pkgs: {

      };

      overlays = [
        nur.overlay
        taffybar.overlay
        #discord.overrideAttrs (_: { src = builtins.fetchTarball "https://discordapp.com/api/download/stable?platform=linux&format=tar.gz"; })
        (final: prev: {
          vimPlugins = prev.vimPlugins // (missingVimPluginsInNixpkgs prev.pkgs);
          discord = prev.discord.overrideAttrs (_: { src = builtins.fetchTarball https://discordapp.com/api/download/stable?platform=linux&format=tar.gz; });
        })
      ];

      unfreePredicate = lib: pkg: builtins.elem (lib.getName pkg) [
        "slack"
        "ngrok"
        "steam"
        "steam-original"
        "steam-runtime"
        "discord"
      ];

      common_modules = [
        ./modules/kitty.nix
        ./modules/cli
        ./modules/fonts.nix
        ./modules/git.nix
        ./modules/programming.nix
        ./modules/system-management
        ./modules/nvim
      ];
    in
    {
      homeConfigurations = {
        nixos = inputs.home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = "/home/silas";
          username = "silas";
          configuration = { config, lib, pkgs, ... }@configInput:
            {
              # NOTE: Here we are injecting colorscheme so that it is passed down all the imports
              _module.args = {
                colorscheme = (import ./colorschemes/tokyonight.nix);
              };

              nixpkgs.config.allowUnfreePredicate = (unfreePredicate lib);
              nixpkgs.overlays = overlays;

              # Let Home Manager install and manage itself.
              programs.home-manager.enable = true;

              imports = common_modules ++ [
                ./modules/browser.nix
                ./modules/desktop-environment
              ];

              # Packages that don't fit in the modules that we have
              home.packages = with pkgs; [
                nodejs
                discord
                slack
                steam
                postgresql
                lshw
                scrot
              ];
            };
        };
      };
    };
}
