{
  description = "VS Code Extension Development Environment";

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
      in {
        devShells.default = pkgs.mkShell {
          name = "vscode-extension-dev";
          
          buildInputs = with pkgs; [
            # Node.js and package managers
            nodejs_22
            nodePackages.npm
            nodePackages.yarn
            
            # VS Code extension development tools
            # Note: vsce and generator-code will be installed via npm in the shell
            nodePackages.yo
            
            # TypeScript and development tools
            nodePackages.typescript
            nodePackages.ts-node
            
            # Code quality tools
            nodePackages.eslint
            nodePackages.prettier
            
            # General development tools
            git
            #vscodium
          ];

          shellHook = ''
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "🚀 VS Code Extension Development Environment"
            echo ""
            echo "📦 Available tools:"
            echo "   - Node.js $(node --version)"
            echo "   - npm $(npm --version)"
            echo "   - TypeScript $(tsc --version)"
            echo "   - VS Code Extension Manager (vsce)"
            echo "   - Yeoman Generator (yo)"
            echo ""
            echo "🛠️  Quick start commands:"
            echo "   npm install -g @vscode/vsce generator-code  # Install extension tools"
            echo "   yo code                    # Generate new VS Code extension"
            echo "   npm install               # Install dependencies"
            echo "   npm run compile           # Compile TypeScript"
            echo "   vsce package              # Package extension"
            echo "   code .                    # Open in VS Code"
            echo ""
            echo "📁 Project directory: $(pwd)"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            
            # Set up npm to use a local directory for global packages
            export NPM_CONFIG_PREFIX=$PWD/.npm-global
            export PATH=$PWD/.npm-global/bin:$PATH
            mkdir -p .npm-global
            
            # Install VS Code extension tools automatically
            if [ ! -f ".npm-global/bin/vsce" ]; then
              echo "Installing VS Code extension development tools..."
              npm install -g @vscode/vsce generator-code > /dev/null 2>&1
              echo "✅ Extension tools installed!"
            fi
          '';
        };
      }
    );
}
