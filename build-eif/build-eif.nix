let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11";
  pkgs = import nixpkgs { };
in
pkgs.rustPlatform.buildRustPackage {
  name = "aws-nitro-enclaves-build-eif";
  src = builtins.fetchTarball {
    url = "https://github.com/aws/aws-nitro-enclaves-cli/archive/refs/tags/v1.4.0.tar.gz";
    sha256 = "1a3nlh7ls327yxk1f28qfz9hvbzkys0gv2lvzxq91kzaidlin2gf";
  };

  buildInputs = with pkgs; [
    openssl
  ];
  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  OPENSSL_DIR = "${pkgs.openssl.dev}";
  OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
  OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

  cargoHash = "sha256-pEUVxf/Mt7zIKVjRZlHa3Btk5oWeHIjesQ4+TvrZTA4";

  # We only want to build the enclave_build portion of the nitro-cli tool.
  # Tell cargo to only build the enclave_build package.
  cargoBuildFlags = [
    "-p"
    "enclave_build"
  ];

  # The nix buildRustPackage not only runs cargo build but also cargo
  # test. The tests depend on docker, however, which is not available
  # in the build sandbox (nor should it be for reproducibility purposes).
  # Tell nix not to run the tests so that our build passes successfully
  doCheck = false;

  # Copy the blobs to the output directory after building and installing
  # the enclave_build tool. Do not perform this copy during postInstall
  # as nix runs ELF processing tools, which will attempt (and fail) to
  # run on the blob binaries.
  postFixup = ''
    cp -r $src/blobs $out/
  '';
}
