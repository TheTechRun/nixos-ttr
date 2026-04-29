{config, pkgs, ... }:

{
  home.packages = with pkgs; [

clang-tools # c++ 
harper #english spell checker
kotlin-language-server #kotlin
gopls # go
# javascript-typescript-langserver
nodePackages.typescript-language-server  # TypeScript/JavaScript
nodePackages.bash-language-server # Bash
nixd # Nix language server
python3Packages.python-lsp-server #Python
rust-analyzer # Rust
lua-language-server # Lua
marksman # Markdown
vscode-langservers-extracted # HTML, CSS, JSON, ESLint
yaml-language-server # yaml
nodePackages.typescript-language-server  # TypeScript/JavaScript
nodePackages.bash-language-server        # Bash
nixd                                       # Nix language server
python3Packages.python-lsp-server         # Python
rust-analyzer                              # Rust
lua-language-server                       # Lua
marksman                                   # Markdown
vscode-langservers-extracted              # HTML, CSS, JSON, ESLint
];

}