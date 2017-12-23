with (import <nixpkgs>) {};

let
apps = [ makeWrapper stack bash haskellPackages.ghc-mod cabal-install haskellPackages.stylish-haskell haskellPackages.hindent ];
in
rec {
  sbt3-px = sublime3.overrideDerivation (oldAttrs: rec {
    name = "sbt3-px";
    buildInputs = oldAttrs.propagatedBuildInputs ++ apps;
    phases = [ "installPhase" "postInstall" ];
    postInstall = ''
      echo "==== POST INSTALL ====";
      for exe in "$out/bin/"* ; do
        echo ${builtins.concatStringsSep ":" (map (app: app.out + "/bin") apps)}
	wrapProgram "$exe" --prefix PATH ":" ${builtins.concatStringsSep ":" (map (app: app.out + "/bin") apps)}
      done
      '';
    });
}
