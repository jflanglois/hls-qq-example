{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    haskellNix.url = "github:input-output-hk/haskell.nix/master";
  };
  outputs = { self, flake-utils, haskellNix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        indexState = "2021-02-16T00:00:00Z";
        pkgs = haskellNix.legacyPackages."${system}";
        drv = pkgs.haskell-nix.project {
          src = pkgs.haskell-nix.haskellLib.cleanGit {
            name = "hls-qq-example";
            src = ./.;
          };
          compiler-nix-name = "ghc884";
          index-state = indexState;
        };
      in {
        defaultPackage = drv.hls-qq-example.components.exes.plan;
        devShell = drv.shellFor {
          withHoogle = true;
          tools = {
            cabal = { version = "3.2.0.0"; index-state = indexState; };
            hoogle = { version = "5.0.18.1"; index-state = indexState; };
            haskell-language-server = { version = "0.9.0.0"; index-state = indexState; };
            hlint = { version = "3.2.7"; index-state = indexState; };
          };
          exactDeps = true;
        };
        defaultApp = { type = "app"; program = "${self.defaultPackage."${system}"}/bin/plan"; };
        apps.calculateMaterializedSha = { type = "app"; program = "${(drv // { checkMaterialization = true; }).plan-nix.passthru.calculateMaterializedSha}"; };
      }
    );
}
