{ inputs, self }:

final: prev:
let
  wineBuilder = wine: build: extra: (import ./wine ({
    inherit inputs build;
    inherit (prev) lib pkgsCross pkgsi686Linux fetchFromGitHub callPackage stdenv_32bit;
    pkgs = prev;
    supportFlags = (import ./wine/supportFlags.nix).${build};
  } // extra)).${wine};
in
{
  osu-lazer-bin = prev.callPackage ./osu-lazer-bin { };

  osu-stable = prev.callPackage ./osu-stable {
    wine = final.wine-osu;
    inherit (final) winestreamproxy;
  };

  rocket-league = prev.callPackage ./rocket-league { wine = final.wine-tkg; };

  technic-launcher = prev.callPackage ./technic-launcher { };

  winestreamproxy = prev.callPackage ./winestreamproxy { wine = final.wine-tkg; };

  wine-osu = wineBuilder "wine-osu" "base" { };

  wine-tkg = wineBuilder "wine-tkg" "base" { };

  wine-tkg-full = wineBuilder "wine-tkg" "full" { };
}
