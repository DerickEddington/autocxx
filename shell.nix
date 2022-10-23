{ pkgs ? import <nixpkgs> {} }:

let
  inherit (pkgs.llvmPackages) libclang libllvm clang;
  inherit (pkgs) mkShell;
in
mkShell {
  # Was not strictly needed when I wrote this, but is logical and could
  # hypothetically be needed for unknown possible future changes to autocxx and
  # its dependencies.
  packages = [
    clang    # In case it's needed, e.g. by the clang-sys crate.
    libllvm  # For llvm-config, which the clang-sys crate says it uses.
  ];
  buildInputs = [
    # Placed here, so it's available for both build-time and run-time of any
    # artifacts.
    libclang
  ];

  shellHook = ''
    # Needed by the clang-sys crate.
    export LIBCLANG_PATH="${libclang.lib}/lib"

    # Needed by the bindgen crate. These file-content substitutions are somewhat
    # similar to what the nixpkgs' clang-wrapper script does.
    export BINDGEN_EXTRA_CLANG_ARGS="$(< ${clang}/nix-support/cc-cflags) $(< ${clang}/nix-support/libc-cflags) $(< ${clang}/nix-support/libcxx-cxxflags)"
  '';

  # Probably could leave all/some enabled, but this seems more robust for
  # unknown possible future changes to autocxx and its dependencies.
  hardeningDisable = ["all"];
}
