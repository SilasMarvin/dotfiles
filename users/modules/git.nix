{ config, pkgs, libs, ... }:
{
  home.packages = with pkgs; [
    git-crypt
    gitAndTools.delta
  ];
  programs.git = {
    enable = true;
    userName = "SilasMarvin";
    userEmail = "19626586+SilasMarvin@users.noreply.github.com";
    extraConfig = {
      core = {
        pager = "delta";
      };
      pull.ff = "only";

      # NOTE: Required so that `go get` can fetch private repos
      # NOTE: cargo breaks if this is present in the config
      # So you have choose between rust or go (Or find a solution for this)
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
      # url = { ssh://git@host = { insteadOf = "otherhost"; };

      delta = {
        features = "side-by-side line-numbers decorations";
      };
      "delta \"decorations\"" = {
        commit-decoration-style = "bold yellow box ul";
        file-style = "bold yellow";
        file-decoration-style = "none";
      };
    };
  };

  programs.gh = {
    enable = true;
    #settings.git_protocol = "ssh";
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
  };
}
