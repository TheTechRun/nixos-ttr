{config, pkgs, ... }:

{
  home.packages = with pkgs; [
    bash-language-server
    clang-tools
    gopls
    harper
    kotlin-language-server
    lua-language-server
    marksman
    nixd
    python3Packages.python-lsp-server
    rust-analyzer
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server
  ];
}
