let
  nixpkgs = import <nixpkgs> {};
  inherit (nixpkgs) stdenv lib;
  node = nixpkgs.nodejs-10_x;
in
stdenv.mkDerivation {
  name = "ci-gate";
  src = lib.cleanSource ./.;
  buildInputs = [ node ];
  buildPhase = ''
    export HOME=$(pwd)
    npm i .
    npm prune --production
  '';
  installPhase = ''
    cp -R . $out
    mkdir -p $out/bin
    echo ${node}/bin/node $out/lib/index.js > $out/bin/ci-gate
    chmod +x $out/bin/ci-gate
  '';
}
