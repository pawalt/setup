# Nix expression to overlay ollama v0.1.16

# TODO(peyton): overlay llama.cpp so we can get mixtral support
# https://github.com/NixOS/nixpkgs/blob/63dd8e1d2e81aaecb7de9b70ca143a607b19a3b9/pkgs/by-name/ll/llama-cpp/package.nix#L128

self: super: {
  ollama = let
    version = "0.1.16";
    src = super.fetchFromGitHub {
      owner = "jmorganca";
      repo = "ollama";
      rev = "v${version}";
      hash = "sha256-K9BBMFhp1qj6Ya8W04FQA1ZUkfwoC870aciS3vUXtb0=";
    };
    vendorHash = "sha256-hjQHoJLzueDT8pEcSSdiR3a4CH4gq+9vG5a3gwkOITE=";

    ldflags = [
      "-s"
      "-w"
      "-X=github.com/jmorganca/ollama/version.Version=${version}"
      "-X=github.com/jmorganca/ollama/server.mode=release"
    ];
  in
    super.ollama.override rec {
      buildGoModule = args:
        super.buildGoModule (args
          // {
            inherit src version vendorHash ldflags;
          });
    };
}
