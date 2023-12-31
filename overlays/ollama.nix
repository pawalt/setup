# Nix expression to overlay ollama v0.1.16

self: super: {
  llama-cpp = super.llama-cpp.overrideAttrs (oldAttrs: rec {
    version = "1662";
    src = super.fetchFromGitHub {
      owner = "ggerganov";
      repo = "llama.cpp";
      rev = "refs/tags/b${version}";
      sha256 = "sha256-Nc9r5wU8OB6AUcb0By5fWMGyFZL5FUP7Oe/aVkiouWg=";
    };
  });

  ollama = super.ollama.overrideAttrs (oldAttrs: rec {
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
  });
}
