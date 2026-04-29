# /home/ttr/nixos-config/modules/flakes/python/flake.nix

{
  description = "Python Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        
        pythonEnv = pkgs.python311.withPackages (ps: with ps; [
          # Web Scraping & Network
          requests
          beautifulsoup4
          httpx
          
          # Data Processing
          numpy
          pandas
          
          # Your commonly used packages based on realitypics_6.py
          requests
          beautifulsoup4
          
          # Additional Utilities
          python-dotenv
          pyyaml
          rich
          tqdm
          
          # Development Tools
          pip
          black
          mypy
          pylint
          pytest
          ipython
        
          # HEIC Converter
          pillow
          pillow-heif
          
          # Other
          tkinter

        ]);

        # Create a wrapper script to run Python files
        pythonWrapper = pkgs.writeScriptBin "runpy" ''
          #!${pkgs.bash}/bin/bash
          if [ -z "$1" ]; then
            echo "Usage: runpy <python-script>"
            exit 1
          fi
          
          exec ${pythonEnv}/bin/python "$@"
        '';

      in {
        devShells.default = pkgs.mkShell {
          name = "python-dev";
          
          buildInputs = with pkgs; [
            pythonEnv
            pythonWrapper
            pyright
            ruff
          ];

          shellHook = ''
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "🐍 Python Development Environment"
            echo "Python version: $(python --version)"
            echo ""
            echo "🛠️  Available commands:"
            echo "- runpy <script.py>  : Run a Python script"
            echo "- python             : Start Python REPL"
            echo ""
            echo "💡 Example: runpy ~/.scripts/cfpics_scripts/realitypics_6.py"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            
            # Add script directories to PATH
            export PATH="$PATH:$HOME/.scripts:$HOME/.scripts/cfpics_scripts"
          '';
        };

        # Add an app that can be run with 'nix run'
        apps.default = {
          type = "app";
          program = "${pythonWrapper}/bin/runpy";
        };
      }
    );
}
