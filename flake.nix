{
  description = "A C Dev Shell";

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
          #"vscode-with-extensions"
          #"vscode"
          "vscode-extension-ms-vscode-cpptools"
        ];
      };
    };
  in
  {
    packages.${system} = {
      default = pkgs.writeShellScriptBin "run" ''
        nix develop -c -- codium .
      '';
    };

    devShells.${system}.default = pkgs.mkShell rec {
      name = "CDevShell";
      buildInputs = with pkgs; [
        libgcc
        gdb
        bashInteractive
        (vscode-with-extensions.override  {
          vscode = pkgs.vscodium;
          vscodeExtensions = with pkgs.vscode-extensions; [
            jnoortheen.nix-ide
            mhutchie.git-graph
            ms-vscode.cpptools
          ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            # {
            #   name = "csharp";
            #   publisher = "ms-dotnettools";
            #   version = "2.30.28";
            #   sha256 = "sha256-+loUatN8evbHWTTVEmuo9Ups6Z1AfqzCyTWWxAY2DY8=";
            # }
          ];
        })
      ];

      shellHook = ''
        export PS1+="${name}> "
        echo "Welcome to the C Dev Shell!"
      '';
    };
  }; 

}

