{
  description = "Inpla: Interaction nets as a programming language";

  inputs = {
    # the nix packages repo, we can pull bison and flex from here
    nixpkgs.url = "github:NixOS/nixpkgs";
    # util lib that lets us quickly package for all available system architectures
    flake-utils.url = "github:numtide/flake-utils";
  };  
  
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system : 
      let   
        pkgs = import nixpkgs { inherit system; };  
        
        mkInpla = {name, buildCmds} :
          with pkgs;                   
          stdenv.mkDerivation {
            inherit name;
            src = self;
            nativeBuildInputs = with pkgs; [bison flex];
            buildPhase = buildCmds;
            installPhase = ''
              mkdir -p $out/bin
              cp inpla $out/bin/inpla
              chmod +x $out
            '';
            meta.mainProgram = "inpla";
          };    
      in
      {
        # single-threaded, default
        default = mkInpla { name = "Inpla (single-threaded)"; buildCmds = ["make"]; };
        # multi-threaded
        thread = mkInpla { 
          name = "Inpla (multi-threaded)"; 
          buildCmds = ''
            make
            make thread
          '';
        };
      }
    );
}
