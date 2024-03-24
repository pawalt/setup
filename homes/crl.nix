{ config, pkgs, ... }: let
  gdk = pkgs.google-cloud-sdk.withExtraComponents( with pkgs.google-cloud-sdk.components; [
    gke-gcloud-auth-plugin
  ]);
in

{
  # PROGRAM CONFIG
  programs.git = {
    enable = true;
    userName  = "Peyton Walters";
    userEmail = "peyton@cockroachlabs.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autostash = true;
      };
    };
  };

  programs.zsh = {
    # we use rancher at work
    initExtra = '' 
      export PATH=$HOME/.rd/bin:$HOME/go/src/github.com/cockroachlabs/managed-service/bin:$HOME/bin:$PATH
    '';

    shellAliases = {
      gmpr = "git machete github create-pr --draft";
    };
  };

  home.packages = [
    gdk
  ];
}
